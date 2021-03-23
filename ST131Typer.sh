#!/bin/bash

###################### ST131Typer ######################

# In silico PCR command line tool for typing Escherichia coli ST131

# For a set of contigs in FASTA format:
# 1) Run seqkit amplicon on file using provided [DATA]/primers.txt
# 2) Compare in silico PCR results to PCR profiles in [DATA]/profiles.txt
# 3) Report results to [OUTDIR]/summary.txt

# Current verison: 1.0 (March 2021)
VERSION="ST131 Subclone Typing In Silico PCR: version 1.0 (March 2021)"
CITATION="TBD"

function help(){
	printf "Usage: ST131Typer.sh [OPTIONS] -i [FASTA or DIR] -o [DIR] -d [DIR]\n"
	printf "\t-h\t\tprint this message\n"
	printf "\t-v\t\tprint the version\n"
	printf "\t-c\t\tcheck SeqKit is in path\n"
	printf "\t-i\t\tfasta contigs file or directory containing multiple files\n"
	printf "\t-o\t\toutput directory\n"
	printf "\t-d\t\tdirectory containing primers.txt and profiles.txt\n"
	printf "\t-r\t\tprint citation\n"
}

function checkSeqKit(){
    PACKAGE=$(command -v seqkit)
    if [ -z "$PACKAGE" ]
    then
        echo -e "\nError: Missing package SeqKit.\n" && exit
        else
        echo -e "\nSeqKit: $PACKAGE"
    fi
}

function checkSize(){
    SIZE=$(grep $1 $OUTDIR/${SAMPLE}.out | awk 'BEGIN { FS=OFS="\t"; }{ print $3-$2 }')
    LOWERLIM="$2"
    UPPERLIM="$3"
    RE='^[0-9]+$'
    if ! [[ $SIZE =~ $RE ]]
    then
        echo "NF"
    elif [[ $SIZE -ge $LOWERLIM ]] && [[ $SIZE -le $UPPERLIM ]]
    then
        echo "$SIZE"
    elif [[ $SIZE -ge $LOWERLIM ]] || [[ $SIZE -le $UPPERLIM ]]
    then
        echo "*${SIZE}*"
    fi
}

OUTDIR=''
INPUT=''
DATA=''

while getopts 'vhci:o:d:r' flag; do
  case "${flag}" in
    v) echo "$VERSION"
       exit 0 ;;
    h) help
       exit 0 ;;
    c) checkSeqKit
       exit 0 ;;
    i) INPUT=$OPTARG ;;
    o) OUTDIR=$OPTARG ;;
    d) DATA=$OPTARG ;;
    r) echo "$CITATION" ;;
  esac
done

if [ $# != 6 ]
then
    help
    exit 1
fi

echo "This is $VERSION" 

printf "\nChecking dependencies..."

#### Check that output directory exists,
# create if it does not ####
if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
    printf "\nOutput directory: %s" $OUTDIR
    else
    printf "\nOutput directory: %s" $OUTDIR
fi

#### Check that data directory exists ####
if [ ! -d $DATA ]; then
    printf "\nError: Data directory does not exist.\n" && exit
    else
    printf "\nData directory: %s" $DATA
fi

#### Check that primer file exists ####
if [ ! -f $DATA/primers.txt ]; then
    printf "\nError: Primer file (primers.txt) does not exist.\n" && exit
    else
    printf "\nPrimer file: %s/primers.txt" $DATA
fi

#### Check that profile file exists ####
if [ ! -f $DATA/profiles.txt ]; then
    printf "\nError: PCR profile file (profiles.txt) does not exist.\n" && exit
    else
    printf "\nProfile file: %s/profiles.txt" $DATA
fi

#### Check that input file/directory exists ####
if [ ! -f $INPUT ] && [ ! -d $INPUT ]; then
    printf "\nError: Input file or directory does not exist.\n" && exit
    else
    printf "\nInput file or directory: %s" $INPUT
fi

#### Check that seqkit is present ####
checkSeqKit

printf "\nChecking samples..."

#### Get a list of samples to be tested ####
if [[ -f $INPUT ]]; then
    basename -- $INPUT > samples.tmp
    INPUTDIR=${INPUT%/*}
    printf "\nOne sample will be processed: %s\n" $INPUT
elif [[ -d $INPUT ]]; then
    SAMPLENUM=$(ls $INPUT | wc -l)
    ls -1 $INPUT > samples.tmp
    INPUTDIR=$(echo $INPUT)
    printf "\n%s samples will be processed:\n" $SAMPLENUM && ls -1 $INPUT
fi

printf "\nStarting analysis...\n"

#### Run seqkit ####

for SAMPLE in $(cat samples.tmp); do

if [ ! -f ${INPUTDIR}/${SAMPLE} ]
then
    printf "\nError: Sample %s does not exist.\n" $SAMPLE
    continue
else
    printf "\nStarting %s...\n" $SAMPLE
    cat ${INPUTDIR}/${SAMPLE} | seqkit amplicon --quiet --seq-type dna --max-mismatch 0 --primer-file $DATA/primers.txt --line-width 0 --bed > $OUTDIR/${SAMPLE}.out
    if [ $? -eq 0 ]
    then
        awk -F "\t" '{ print $4 }' $OUTDIR/${SAMPLE}.out | sed 's/$/\t1/' > found.tmp
        awk -F "\t" '{ print $1 }' $DATA/primers.txt | grep -v -f <(awk -F "\t" '{ print $1 }' found.tmp) - | sed 's/$/\t0/' > missing.tmp
        error=0
    else
        printf "Error: Error when running seqkit amplicon.\n"
        error=1
        continue
    fi
fi

if ! grep -Eq "mdh36" found.tmp && ! grep -Eq "gyrB47" found.tmp
then
    MDH36=NF
    GYRB47=NF
    NOTE="Cannot confirm ST131"
    printf "mdh36 and gyrB47 not found in %s. Cannot confirm ST131. No further analysis was done.\n" $SAMPLE
    printf "$SAMPLE\tNA\tNA\tNA\tNA\tNA\t$NOTE\t$MDH36\t$GYRB47\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n" >> ${OUTDIR}/summary.tmp
    continue

elif ! grep -Eq "mdh36" found.tmp && grep -Eq "gyrB47" found.tmp
then
    MDH36=NF
    GYRB47=$(checkSize "gyrB47" 131 145) 
    NOTE="Cannot confirm ST131"
    printf "gyrB47 was found in %s, but mdh36 was not. Cannot confirm ST131. No further analysis was done.\n" $SAMPLE
    printf "$SAMPLE\tNA\tNA\tNA\tNA\tNA\t$NOTE\t$MDH36\t$GYRB47\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n" >> ${OUTDIR}/summary.tmp
    continue

elif grep -Eq "mdh36" found.tmp && ! grep -Eq "gyrB47" found.tmp
then
    MDH36=$(checkSize "mdh36" 261 289)
    GYRB47=NF
    NOTE="Cannot confirm ST131"
    printf "mdh36 was found in %s, but gyrB47 was not. Cannot confirm ST131. No further analysis was done.\n" $SAMPLE
    printf "$SAMPLE\tNA\tNA\tNA\tNA\tNA\t$NOTE\t$MDH36\t$GYRB47\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\n" >> ${OUTDIR}/summary.tmp
    continue

elif grep -Eq "trpA72" found.tmp
then 
    PLSB=NA
    NUPC=NA
    RMUC=NA
    KEFC=NA
    YBBW=NA
    cat found.tmp missing.tmp > all.tmp
    awk -F "\t" '{ if ($1 == "plsB"||$1 == "nupC"||$1 == "rmuC"||$1 == "kefC"||$1 == "ybbW") $2="x";}1' OFS="\t" all.tmp > tmp && mv tmp all.tmp

elif ! grep -Eq "trpA72" found.tmp
then
    PLSB=$(checkSize "plsB" 588 650)
    NUPC=$(checkSize "nupC" 475 525)
    RMUC=$(checkSize "rmuC" 329 363)
    KEFC=$(checkSize "kefC" 231 255)
    YBBW=$(checkSize "ybbW" 184 204)
    cat found.tmp missing.tmp > all.tmp
fi

MDH36=$(checkSize "mdh36" 261 289)
GYRB47=$(checkSize "gyrB47" 131 145) 
TRPA72=$(checkSize "trpA72" 463 511) 
PRO=$(checkSize "prophage" 781 863)
RFB_O16=$(checkSize "rfb_O16" 703 777)
RFB_O25B=$(checkSize "rfb_O25b" 551 609)
SBMA=$(checkSize "sbmA" 63 69)
PARC=$(checkSize "parC_E84V" 102 112)
FLIC_H4=$(checkSize "fliC_H4" 190 210)
FLIC_H5=$(checkSize "fliC_H5" 583 645)
FIMH30=$(checkSize "fimH30" 336 372)
FIMH35=$(checkSize "fimH35" 475 525)
FIMH27=$(checkSize "fimH27" 385 425)
FIMH22=$(checkSize "fimH22" 266 294)
FIMH41=$(checkSize "fimH41" 90 100)

cat all.tmp | sort -k1 | awk -F "\t" '{ print $2 }' | tr '\n' '-' | sed 's/-$/\n/' > pcr.tmp 
grep -f pcr.tmp $DATA/profiles.txt > profile.tmp

if [ -s profile.tmp ]
then
    TYPE=$(awk -F "\t" '{ print $2 }' profile.tmp)
    NOTE=$(awk -F "\t" '{ print $7 }' profile.tmp)
    CLADE=$(awk -F "\t" '{ print $3 }' profile.tmp)
    O=$(awk -F "\t" '{ print $4 }' profile.tmp)
    H=$(awk -F "\t" '{ print $5 }' profile.tmp)
    fimH=$(awk -F "\t" '{ print $6 }' profile.tmp)
    printf "ST131 PCR profile type: %s\n" $TYPE
    printf "$SAMPLE\t$TYPE\t$CLADE\t$O\t$H\t$fimH\t$NOTE\t$MDH36\t$GYRB47\t$TRPA72\t$RFB_O16\t$RFB_O25B\t$FLIC_H4\t$FLIC_H5\t$FIMH22\t$FIMH27\t$FIMH30\t$FIMH35\t$FIMH41\t$PLSB\t$NUPC\t$KEFC\t$RMUC\t$PRO\t$SBMA\t$YBBW\t$PARC\n" >> $OUTDIR/summary.tmp
    continue
else
    printf "Warning: %s does not match a defined ST131 PCR profile type. Data review is recommended.\n" $SAMPLE
    TYPE="NA"
    NOTE="Non-match profile type. Data review is recommended."
# O-type
    if grep -Eq "rfb_O16" found.tmp && ! grep -Eq "rfb_O25b" found.tmp
    then
        O="O16"
    elif ! grep -Eq "rfb_O16" found.tmp && grep -Eq "rfb_O25b" found.tmp
    then
        O="O25b"
    else
        O="NT"
    fi
# H-type
    if grep -Eq "fliC_H4" found.tmp && ! grep -Eq "fliC_H5" found.tmp
    then
        H="H4"
    elif ! grep -Eq "fliC_H4" found.tmp && grep -Eq "fliC_H5" found.tmp
    then
        H="H5"
    else
        H="NT"
    fi
# fimH allele
    if [ $(grep -c "fimH22\|fimH27\|fimH30\|fimH35\|fimH41" found.tmp) -eq 1 ]
    then
        fimH=$(grep --only-matching "fimH22\|fimH27\|fimH30\|fimH35\|fimH41" found.tmp)
    else
        fimH="NT"
    fi
# Clade
    if grep -Eq "trpA72" found.tmp
    then
        CLADE="A"
    elif [ $(grep -c "plsB\|nupC" found.tmp) -eq 2 ] && [ $(grep -c "rmuC\|kefC\|ybbW" found.tmp) -eq 0 ]
    then
        CLADE="B1"
    elif grep -Eq "nupC" found.tmp && ! grep -Eq "plsB" found.tmp && [ $(grep -c "rmuC\|kefC\|ybbW" found.tmp) -eq 0 ]
    then
        CLADE="B0"
    elif grep -Eq "kefC" found.tmp && ! grep -Eq "rmuC" found.tmp && ! grep -Eq "ybbW" found.tmp && ! grep -Eq "prophage" found.tmp
    then
        CLADE="C0"
    elif grep -Eq "kefC" found.tmp && grep -Eq "rmuC" found.tmp && ! grep -Eq "ybbW" found.tmp && ! grep -Eq "prophage" found.tmp
    then
        CLADE="C1"
    elif grep -Eq "kefC" found.tmp && grep -Eq "rmuC" found.tmp && ! grep -Eq "ybbW" found.tmp && grep -Eq "prophage" found.tmp
    then
        CLADE="C1-M27"
    elif grep -Eq "kefC" found.tmp && ! grep -Eq "rmuC" found.tmp && grep -Eq "ybbW" found.tmp && ! grep -Eq "prophage" found.tmp
    then
        CLADE="C2"
    else
        CLADE="NT"
    fi
    printf "$SAMPLE\t$TYPE\t$CLADE\t$O\t$H\t$fimH\t$NOTE\t$MDH36\t$GYRB47\t$TRPA72\t$RFB_O16\t$RFB_O25B\t$FLIC_H4\t$FLIC_H5\t$FIMH22\t$FIMH27\t$FIMH30\t$FIMH35\t$FIMH41\t$PLSB\t$NUPC\t$KEFC\t$RMUC\t$PRO\t$SBMA\t$YBBW\t$PARC\n" >> $OUTDIR/summary.tmp
    continue
fi

done

mkdir -p $OUTDIR/seqkit_outputs
mv $OUTDIR/*.out $OUTDIR/seqkit_outputs

if [ -f $OUTDIR/summary.tmp ]
then
    cat <(echo -e "Sample\tPCR_Profile_Type\tClade\tO_type\tH_type\tfimH\tDescription\tmdh36\tgyrB47\ttrpA72\trfb_O16\trfb_O25b\tfliC_H4\tfliC_H5\tfimH22\tfimH27\tfimH30\tfimH35\tfimH41\tplsB\tnupC\tkefC\trmuC\tprophage\tsbmA\tybbW\tparC_E84V") $OUTDIR/summary.tmp > $OUTDIR/summary.txt
    rm -f $OUTDIR/summary.tmp *.tmp 
    printf "\nAnalysis complete. See summary.txt in %s for results.\n" $OUTDIR
    exit 0
else
    rm -f *.tmp
    printf "\nError: Missing summary output file."    
    exit
fi


