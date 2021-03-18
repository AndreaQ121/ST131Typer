# ST131Typer: *In silico* PCR command line tool for typing *Escherichia coli* ST131

`ST131Typer` is a simple Bash shell script that utilizes the [SeqKit](https://bioinf.shenwei.me/seqkit/) function [`seqkit amplicon`](https://bioinf.shenwei.me/seqkit/usage/#amplicon) to detect *Escherichia coli* sequence type (ST) 131 and characterize its key subclones from whole genome sequence assemblies.  

This tool is based on the *in vitro* multiplex PCR assays developed by [Johnston et al. *in prep*](), which allows resolution of 15 distinctive molecular subsets within ST131, including 3 within ST131 clade A (or the H41 subclone), 5 within clade B (or the H22 subclone), and 7 within clade C (or the H30 subclone), including subclones C0 (or H30S: 2 subsets), C1 and C1-M27 (or H30R1: 2 subsets), and C2 (or H30Rx: 3 subsets).  

Specifically, this tool uses primer seqeunces to target distinctive nucleotide polymorphisms or sequences in *mdh36*, *gyrB47*, *trpA72*, *sbmA*, *plsB*, *nupC*, *rmuC*, *kefC*, *ybbW*, the O16 and O25b *rfb* variants, five key *fimH* alleles (*fimH22*, *fimH27*, *fimH30*, *fimH35*, and *fimH41*), two *fliC* alleles (H4 and H5), a (subclone-specific) fluoroquinolone resistance-associated *parC* allele, and a (subclone-specific) prophage marker.  


NOTE: This works as well as your assembly...

## Requirements

* [SeqKit](https://bioinf.shenwei.me/seqkit/) (>= v0.14.0) plus all dependencies
    * Go to the SeqKit [Installation Page](https://github.com/shenwei356/seqkit#installation) for install options.
* `primers.txt` file located in the ST131Typer/data directory
* `profiles.txt` file located in the ST131Typer/data directory

## Installation

```
git clone https://github.com/JohnsonSingerLab/ST131Typer.git/
```

### Check Installation

Ensure the desired ST131Typer version is installed:

```
./ST131Typer.sh -v
```

Check that the dependency SeqKit is installed in your path:

```
./ST131Typer.sh -c
```

## Usage

### Input Requirements

* assembly in FASTA format or directory containing multiple assemblies in FASTA format; assemblies can be in multiple contigs
* directory to output the results into
* directory containing both the `primers.txt` and `profiles.txt` files

### Command line options
```
% ./ST131Typer.sh
Usage: ST131Typing.sh [OPTIONS] --input [FASTA or DIR] --outdir [DIR] --bin [DIR]
	-h		print this message
	-v		print the version
	-c		check SeqKit is in path
	-i		fasta contigs file or directory containing multiple files
	-o		output directory
	-d		directory containing primers.txt and profiles.txt
  	-r    		prints citation
```

### Output

Within the user defined output directory, there will be two items:

* summary.txt: A simple tab-separated summary of the results
* seqkit_outputs: A directory containing the output(s) of `seqkit amplicon` in [BED format](http://genome.ucsc.edu/FAQ/FAQformat.html#format1), one file for each assembly file input.  

#### summary.txt

The `summary.txt` file is a tab-separated results summary with one line for each assembly file input.

Column | Description
---------|---------
Sample | Name of assembly file
PCR_Profile_Type | Numerical ST131 PCR profile type from [Johnston et al. *in prep*]() [1-15]
Clade | ST131 clade designation [A, B0, B1, C0, C1, C1-M27, or C2]
O_type | O antigen [O16 or O25b *rfb* variant]
H_type | H antigen [*fliC* allele H4 or H5]
fimH | *fimH* allele [*fimH22*, *fimH27*, *fimH30*, *fimH35*, or *fimH41*] 
Description | Descritpion of the ST131 subclone/clade associated with the ST131 PCR profile type
mdh36 | Length (bp) of *mdh36* "amplicon" identified [expected length: ~275 bp]
gyrB47 | Length (bp) of *gyrB47* "amplicon" identified [expected length: ~138 bp]
trpA72 | Length (bp) of *trpA72* "amplicon" identified [expected length: ~487 bp]
rfb_O16 | Length (bp) of *rfb* O16 allele "amplicon" identified [expected length: ~138 bp]
rfb_O25b | Length (bp) of *rfb* O25b allele "amplicon" identified [expected length: ~138 bp]
fliC_H4 | Length (bp) of *fliC* H4 allele "amplicon" identified [expected length: ~138 bp]
fliC_H5 | Length (bp) of *fliC* H4 allele "amplicon" identified [expected length: ~138 bp]
fimH22 | Length (bp) of *fimH22* allele complex "amplicon" identified [expected length: ~138 bp]
fimH27 | Length (bp) of *fimH27* allele complex "amplicon" identified [expected length: ~138 bp]
fimH30 | Length (bp) of *fimH30* allele complex "amplicon" identified [expected length: ~138 bp]
fimH35 | Length (bp) of *fimH35* allele complex "amplicon" identified [expected length: ~138 bp]
fimH41 | Length (bp) of *fimH41* allele complex "amplicon" identified [expected length: ~138 bp]
plsB | Length (bp) of *plsB* "amplicon" identified [expected length: ~138 bp]
nupC | Length (bp) of *nupC* "amplicon" identified [expected length: ~138 bp]
kefC | Length (bp) of *kefC* "amplicon" identified [expected length: ~138 bp]
rmuC | Length (bp) of *rmuC* "amplicon" identified [expected length: ~138 bp]
prophage | Length (bp) of the prophage marker "amplicon" identified [expected length: ~138 bp]
sbmA | Length (bp) of *sbmA* "amplicon" identified [expected length: ~138 bp]
ybbW | Length (bp) of *ybbW* "amplicon" identified [expected length: ~138 bp]
parC_E84V | Length (bp) of *parC* E84V "amplicon" identified [expected length: ~138 bp]



Character | Meaning
---------|---------




## Citation
TBD

## Contributors
ELizabeth Miller (millere@umn.edu)
