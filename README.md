[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

# ST131Typer

*In silico* PCR command line tool for typing *Escherichia coli* ST131

## Description

`ST131Typer` is a simple Bash shell script that utilizes the [SeqKit](https://bioinf.shenwei.me/seqkit/) function [`seqkit amplicon`](https://bioinf.shenwei.me/seqkit/usage/#amplicon) to detect *Escherichia coli* sequence type (ST) 131 and characterize its key subclones from whole genome sequence (WGS) assemblies.  

This tool is the *in silico* version of the *in vitro* multiplex PCR assays developed by [Johnston et al. *in prep*](). The assays allows resolution of 15 distinctive molecular subsets within ST131, including 3 within ST131 clade A (or the H41 subclone), 5 within clade B (or the H22 subclone), and 7 within clade C (or the H30 subclone), including subclones C0 (or H30S: 2 subsets), C1 and C1-M27 (or H30R1: 2 subsets), and C2 (or H30Rx: 3 subsets).  

Specifically, this tool uses primer sequences to target distinctive nucleotide polymorphisms or sequences in *mdh36*, *gyrB47*, *trpA72*, *sbmA*, *plsB*, *nupC*, *rmuC*, *kefC*, *ybbW*, the O16 and O25b *rfb* variants, five key *fimH* alleles (*fimH22*, *fimH27*, *fimH30*, *fimH35*, and *fimH41*), two *fliC* alleles (H4 and H5), a (subclone-specific) fluoroquinolone resistance-associated *parC* allele, and a (subclone-specific) prophage marker. If the target polymorphism or sequence is found in a WGS assembly, the resulting "amplicon" (the sequence that lies between and includes the primer pair), or target, is output.   



## Requirements

* [SeqKit](https://bioinf.shenwei.me/seqkit/) (>= v0.14.0)
    * Go to SeqKit's [Installation Page](https://github.com/shenwei356/seqkit#installation) for install options.
* `primers.txt` file located in the `data` directory
* `profiles.txt` file located in the `data` directory

## Installation

This will install the latest version directly from GitHub.

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

### Command Line Options
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

### Example Usage

Single FASTA file:
```
% ./ST131Typer.sh -i MVAST020.fasta -o example_output -d data
```

Directory containing multiple FASTA files:
```
% ./ST131Typer.sh -i data/assemblies -o example_output -d data
```

Assembly FASTA files of strains representing 14 of the 15 ST131 PCR profile types described in [Johnston et al. *in prep*]() were downloaded from [EnteroBase's Escherichia/Shigella Database](https://enterobase.warwick.ac.uk/species/index/ecoli) and can be found in the `data`/`assemblies` directory. 

PCR Type | Representative Strain | EnteroBase Assembly | Clade | O:H Type | fimH Allele
---------|---------|---------|---------|---------|---------
1 | MVAST020 | ESC_AA8761AA_AS | A | O16:H5 | 41
2 | M670745 | ESC_IA8762AA_AS | A | O25b:H5 | 41
3 | BS488 | ESC_NB9781AA_AS | A | O25b:H4 | 41
4 | H17 | ESC_BA4271AA_AS | B0 | O25b:H4 | 27
5 | JJ1897 | ESC_BA3173AA_AS | B0 | O25b:H4 | 22
6 | JJ1969 | ESC_BA4297AA_AS | B1 | O25b:H4 | 22
7 | G199 | ESC_CA4199AA_AS | B1 | O25b:H4 | 30
8 | ZH071 | ESC_BA5429AA_AS | B1 | O25b:H4 | 94
9 | CD306 | ESC_GA4681AA_AS | C0 | O25b:H4 | 30
10 | BS448 | ESC_NB9779AA_AS | C0 | O25b:H4 | 30
11 | JJ2193 | ESC_BA9567AA_AS | C1 | O25b:H4 | 30
12 | U024 | ESC_CA3641AA_AS | C1-M27 | O25b:H4 | 30
13 | JJ1886 | ESC_GA4805AA_AS | C2 | O25b:H4 | 30
14 | U004 | ESC_CA5485AA_AS | C2 | O25b:H4 | 35
15 | MISSING | | | |

### Output

Within the user-defined output directory, there will be two items:

* `summary.txt`: A simple tab-separated summary of the results
* `seqkit_outputs`: A directory containing the output(s) of `seqkit amplicon` in [BED format](http://genome.ucsc.edu/FAQ/FAQformat.html#format1), one file for each assembly file input.  

The `summary.txt` file is a tab-separated results summary with one line for each assembly file input.

Column | Description | Possible Values
---------|---------|---------
Sample | Name of assembly file
PCR_Profile_Type | Numerical ST131 PCR profile type from [Johnston et al. *in prep*]() | 1-15
Clade | ST131 clade designation | A, B0, B1, C0, C1, C1-M27, or C2
O_type | O antigen | O16 or O25b 
H_type | H antigen | H4 or H5 
fimH | *fimH* allele | *fimH22*, *fimH27*, *fimH30*, *fimH35*, or *fimH41*
Description | Description of the ST131 subclone/clade associated with the ST131 PCR profile type
mdh36 | Length (bp) of *mdh36* target identified | ~275 bp [expected]
gyrB47 | Length (bp) of *gyrB47* target identified | ~138 bp [expected]
trpA72 | Length (bp) of *trpA72* target identified | ~487 bp [expected]
rfb_O16 | Length (bp) of *rfb* O16 allele target identified | ~732 bp [expected]
rfb_O25b | Length (bp) of *rfb* O25b allele target identified | ~557 bp [expected]
fliC_H4 | Length (bp) of *fliC* H4 allele target identified | ~199 bp [expected]
fliC_H5 | Length (bp) of *fliC* H4 allele target identified | ~614 bp [expected]
fimH22 | Length (bp) of *fimH22* allele complex target identified | ~279 bp [expected]
fimH27 | Length (bp) of *fimH27* allele complex target identified | ~405 bp [expected]
fimH30 | Length (bp) of *fimH30* allele complex target identified | ~350 bp [expected]
fimH35 | Length (bp) of *fimH35* allele complex target identified | ~500 bp [expected]
fimH41 | Length (bp) of *fimH41* allele complex target identified | ~92 bp [expected]
plsB | Length (bp) of *plsB* target identified | ~628 bp [expected]
nupC | Length (bp) of *nupC* target identified | ~498 bp [expected]
kefC | Length (bp) of *kefC* target identified | ~238 bp [expected]
rmuC | Length (bp) of *rmuC* target identified | ~353 bp [expected]
prophage | Length (bp) of the prophage marker target identified | ~822 bp [expected]
sbmA | Length (bp) of *sbmA* target identified | ~64 bp [expected]
ybbW | Length (bp) of *ybbW* target identified | ~194 bp [expected]
parC_E84V | Length (bp) of *parC* E84V target identified | ~107 bp [expected]

Within the target columns, there are five possible entries:  

Character | Meaning
---------|---------
[*NUM*] | Length (bp) of target (sequence between and including the primer pair)
\*[*NUM*]\* | Length (bp) of target falls outside +/- 5% of the expected length
NA | Not applicable to the typing of the sample (i.e. clade B- and C-associated primer pairs are not relevant for typing of clade A isolates)
NF | Not found; primer pair was not identified or not identified on the same contig 
NT | Non-typable; O-type, H-type, *fimH*-type or clade could not be determined. Could be due to missing target or the presence of multiple conflicting targets.

## Citation

```
% ./ST131Typer.sh -r
TBD
```
If you use ST131Typer in your work, please cite:  

**TBD**
