![version](https://img.shields.io/badge/version-1.0.0-blue)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-green.svg)](https://www.gnu.org/licenses/old-licenses/gpl-3.0.en.html)
[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)


# ST131Typer

*In silico* PCR command line tool for typing *Escherichia coli* ST131

## Description

`ST131Typer` is a simple Bash shell script that utilizes the [SeqKit](https://bioinf.shenwei.me/seqkit/) function [`seqkit amplicon`](https://bioinf.shenwei.me/seqkit/usage/#amplicon) to detect *Escherichia coli* sequence type (ST) 131 and characterize its key subclones from preassembled partial or complete genome assemblies.  

This tool is the *in silico* version of the *in vitro* multiplex PCR assays developed by [Johnston et al. *in prep*](). The lab assay allows resolution of 15 distinctive molecular subsets within ST131, including 3 within ST131 clade A (i.e. the *H*41 subclone), 5 within clade B (i.e. the *H*22 subclone), and 7 within clade C (i.e. the *H*30 subclone), including subclones C0 (i.e. *H*30S: 2 subsets), C1 and C1-M27 (i.e. *H*30R1: 2 subsets), and C2 (i.e. *H*30Rx: 3 subsets).  

Specifically, this tool uses primer sequences to target distinctive nucleotide polymorphisms or sequences in:

* *mdh36*
* *gyrB47*
* *trpA72*
* *sbmA*
* *plsB*
* *nupC*
* *rmuC*
* *kefC*
* *ybbW*
* O16 and O25b *rfb* variants
* five key *fimH* alleles (*fimH22*, *fimH27*, *fimH30*, *fimH35*, and *fimH41*)
* two *fliC* alleles (H4 and H5)
* (subclone-specific) fluoroquinolone resistance-associated *parC* allele
* (subclone-specific) prophage marker

If the target polymorphism or sequence is found in a WGS assembly, the resulting target sequence (the sequence that lies between and includes the primer pair), or "amplicon", is output.   

### :warning: A word of caution...

**ST131Typer is only as accurate as the quality of the input sequences.** Less complete assemblies increase the likelihood that a target sequence is fragmented or incomplete and therefore not identified by ST131Typer. Be aware that ST131Typer will not consider a target present if:

* The target spans two assembly contigs/scaffolds (i.e. the forward and reverse primers are on different contigs/scaffolds).
* Only one primer of a pair is identified.
* The primer sequences do not match 100% with the target.

BLAST-based tools, such as those on the [Center for Genomic Epidemiology (CGE) website](https://www.genomicepidemiology.org/), utilize curated databases of complete allele sequences and do not require a 100% match between the input assembly and the allele sequences. Since these tools are simply reporting the top BLAST hit(s), they are less affected by incomplete genome assemblies or allelic variation in primer regions than `ST131Typer`. The benefit of using `ST131Typer` over publicly available BLAST-based tools is that it provides typing resolution beyond just serotype and *fimH* type.

## Requirements

* [SeqKit](https://bioinf.shenwei.me/seqkit/) (>= v0.14.0)
    * Go to SeqKit's [Installation Page](https://github.com/shenwei356/seqkit#installation) for install options.

## Installation

This will install the latest version directly from GitHub:

```
git clone https://github.com/JohnsonSingerLab/ST131Typer.git
```

Change permissions to make `ST131Typer.sh` executable:
```
cd ST131Typer
chmod +x ST131Typer.sh
```

### Check Installation

Ensure the desired ST131Typer version is installed:

```
./ST131Typer.sh -v
```

Check that the dependency, SeqKit, is installed in your path:

```
./ST131Typer.sh -c
```

## Usage

### Input Requirements

* assembly in FASTA format or directory containing multiple assemblies in FASTA format; assemblies can be in multiple contigs
* directory to output the results into

### Command Line Options
```
% ./ST131Typer.sh
Usage: ST131Typer.sh [OPTIONS] -i [FASTA or DIR] -o [DIR]
	-h		print this message
	-v		print the version
	-c		check SeqKit is in path
	-i		fasta contigs file or directory containing multiple files
	-o		output directory
  	-r    		prints citation
```

### Example Usage

Single FASTA file:
```
% ./ST131Typer.sh -i data/assemblies/BS448.fasta -o example_output
```

Directory containing multiple FASTA files:
```
% ./ST131Typer.sh -i data/assemblies -o example_output
```

Assembly FASTA files of strains representing 14 of the 15 ST131 PCR profile types described in [Johnston et al. *in prep*]() were downloaded from [EnteroBase's Escherichia/Shigella Database](https://enterobase.warwick.ac.uk/species/index/ecoli) and can be found in the `data`/`assemblies` directory. 

PCR Type | Representative Strain | Clade | O:H Type | *fimH* Allele | Description
---------|---------|---------|---------|---------|---------
1 | MVAST020 | A | O16:H5 | *H*41 | *H*41 / A (O16:H4 variant)
2 | BS488 | A | O25b:H4 | *H*41 | *H*41 / A (O25b:H4 variant)
3 | M670745 | A | O25b:H5 | *H*41 | *H*41 / A (O25b:H5 variant)
4 | H17 | B0 | O25b:H4 | *H*27 | *H*27 / B0
5 | JJ1897 | B0 | O25b:H4 | *H*22 | *H*22 / B0
6 | JJ1969 | B1 | O25b:H4 | *H*22 | *H*22 / B1
7 | ZH071 | B1 | O25b:H4 | *H*94 | *H*94 (non-*H*22) / B1
8 | G199 | B1 | O25b:H4 | *H*30 | *H*30 / B1
9 | CD306 | C0 | O25b:H4 | *H*30 | *H*30S / C0
10 | BS448 | C0 | O25b:H4 | *H*30 | *H*30S / C0 (*parC* E84V and FQ-R)
11 | JJ2193 | C1 | O25b:H4 | *H*30 | *H*30R1 non-C1-M27 / C1
12 | U024 | C1-M27 | O25b:H4 | *H*30 | *H*30R1 C1-M27 / C1-M27
13 | JJ1886 | C2 | O25b:H4 | *H*30 | *H*30Rx / C2
14 | U004 | C2 | O25b:H4 | *H*35 | *H*30Rx (*fimH35*) / C2
15 | Not Available | C2 | ONT:H4 | *H*30 | *H*30Rx / C2 (non-O-typable)

### Output

Within the user-defined output directory, there will be two items:

* `summary.txt`: A simple tab-separated summary of the results
* `seqkit_outputs`: A directory containing the output(s) of `seqkit amplicon` in [BED format](http://genome.ucsc.edu/FAQ/FAQformat.html#format1), one file for each assembly file input.  

The `summary.txt` file is a tab-separated results summary with one line for each assembly file input.

Column | Description | Possible Values
---------|---------|---------
Sample | Name of assembly file
PCR_Profile_Type | Numerical ST131 PCR profile type from [Johnston et al. *in prep*]() | 1-15, "Unknown", or "non-ST131"
Clade | ST131 clade designation | A, B0, B1, C0, C1, C1-M27, or C2
O_type | O antigen | O16 or O25b 
H_type | H antigen | H4 or H5 
fimH | *fimH* allele | *fimH22*, *fimH27*, *fimH30*, *fimH35*, or *fimH41*
Description | Description of the ST131 subclone/clade associated with the ST131 PCR profile type
mdh36 | Length (bp) of *mdh36* target identified | ~275 <sup>*</sup>
gyrB47 | Length (bp) of *gyrB47* target identified | ~138 <sup>*</sup>
trpA72 | Length (bp) of *trpA72* target identified | ~487 <sup>*</sup>
rfb_O16 | Length (bp) of *rfb* O16 allele target identified | ~732 <sup>*</sup>
rfb_O25b | Length (bp) of *rfb* O25b allele target identified | ~557 <sup>*</sup>
fliC_H4 | Length (bp) of *fliC* H4 allele target identified | ~199 <sup>*</sup>
fliC_H5 | Length (bp) of *fliC* H4 allele target identified | ~614 <sup>*</sup>
fimH22 | Length (bp) of *fimH22* allele complex target identified | ~279 <sup>*</sup>
fimH27 | Length (bp) of *fimH27* allele complex target identified | ~405 <sup>*</sup>
fimH30 | Length (bp) of *fimH30* allele complex target identified | ~350 <sup>*</sup>
fimH35 | Length (bp) of *fimH35* allele complex target identified | ~500 <sup>*</sup>
fimH41 | Length (bp) of *fimH41* allele complex target identified | ~92 <sup>*</sup>
plsB | Length (bp) of *plsB* target identified | ~628 <sup>*</sup>
nupC | Length (bp) of *nupC* target identified | ~498 <sup>*</sup>
kefC | Length (bp) of *kefC* target identified | ~238 <sup>*</sup>
rmuC | Length (bp) of *rmuC* target identified | ~353 <sup>*</sup>
prophage | Length (bp) of the prophage marker target identified | ~822 <sup>*</sup>
sbmA | Length (bp) of *sbmA* target identified | ~64 <sup>*</sup>
ybbW | Length (bp) of *ybbW* target identified | ~194 <sup>*</sup>
parC_E84V | Length (bp) of *parC* E84V target identified | ~107 <sup>*</sup>

<sup>*</sup> Within the target columns, there are five possible entries:  

Character | Meaning
---------|---------
[*NUM*] | Length (bp) of target (sequence between and including the primer pair)
\*[*NUM*]\* | Length (bp) of target falls outside +/- 5% of the expected length
NA | Not applicable to the typing of the sample (i.e. non-ST131 strain; clade B- and C-associated primer pairs are not relevant for typing of clade A isolates)
NF | Not found; primer pair was not identified or was not identified on the same contig 
NT | Non-typable; O-type, H-type, *fimH*-type or clade could not be determined. Could be due to missing target or the presence of multiple conflicting targets.

## Citation

```
./ST131Typer.sh -r
```
If you use ST131Typer in your work, please cite:  

Johnston, BD, Gordon, DH, Burn, S, Johnson, TJ, Weber, BP, Miller, EA, and Johnson, JR. Novel Multiplex PCR Method for High-Resolution Subclonal Assignment and Characterization of *Escherichia coli* Sequence Type 131 Isolates.  

:link:
