# ST131Typer: *In silico* PCR command line tool for typing *Escherichia coli* ST131

`ST131Typer` is a simple Bash shell script that utilizes the [SeqKit](https://bioinf.shenwei.me/seqkit/) function [`seqkit amplicon`](https://bioinf.shenwei.me/seqkit/usage/#amplicon) to detect *Escherichia coli* sequence type (ST) 131 and characterize its key subclones from whole genome sequence (WGS) assemblies.  

This tool is based on the *in vitro* multiplex PCR assays developed by [Johnston et al. *in prep*](), which allows resolution of 15 distinctive molecular subsets within ST131, including 3 within ST131 clade A (or the H41 subclone), 5 within clade B (or the H22 subclone), and 7 within clade C (or the H30 subclone), including subclones C0 (or H30S: 2 subsets), C1 and C1-M27 (or H30R1: 2 subsets), and C2 (or H30Rx: 3 subsets).  

Specifically, this tool uses primer sequences to target distinctive nucleotide polymorphisms or sequences in *mdh36*, *gyrB47*, *trpA72*, *sbmA*, *plsB*, *nupC*, *rmuC*, *kefC*, *ybbW*, the O16 and O25b *rfb* variants, five key *fimH* alleles (*fimH22*, *fimH27*, *fimH30*, *fimH35*, and *fimH41*), two *fliC* alleles (H4 and H5), a (subclone-specific) fluoroquinolone resistance-associated *parC* allele, and a (subclone-specific) prophage marker. If the target polymorphism or sequence is found in a WGS assembly, the resulting "amplicon" (the sequence that lies between and includes the primer pair), or target, is output.   


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

Within the user-defined output directory, there will be two items:

* `summary.txt`: A simple tab-separated summary of the results
* `seqkit_outputs`: A directory containing the output(s) of `seqkit amplicon` in [BED format](http://genome.ucsc.edu/FAQ/FAQformat.html#format1), one file for each assembly file input.  

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
mdh36 | Length (bp) of *mdh36* target identified [Expected: ~275 bp]
gyrB47 | Length (bp) of *gyrB47* target identified [Expected: ~138 bp]
trpA72 | Length (bp) of *trpA72* target identified [Expected: ~487 bp]
rfb_O16 | Length (bp) of *rfb* O16 allele target identified [Expected: ~732 bp]
rfb_O25b | Length (bp) of *rfb* O25b allele target identified [Expected: ~557 bp]
fliC_H4 | Length (bp) of *fliC* H4 allele target identified [Expected: ~199 bp]
fliC_H5 | Length (bp) of *fliC* H4 allele target identified [Expected: ~614 bp]
fimH22 | Length (bp) of *fimH22* allele complex target identified [Expected: ~279 bp]
fimH27 | Length (bp) of *fimH27* allele complex target identified [Expected: ~405 bp]
fimH30 | Length (bp) of *fimH30* allele complex target identified [Expected: ~350 bp]
fimH35 | Length (bp) of *fimH35* allele complex target identified [Expected: ~500 bp]
fimH41 | Length (bp) of *fimH41* allele complex target identified [Expected: ~92 bp]
plsB | Length (bp) of *plsB* target identified [Expected: ~628 bp]
nupC | Length (bp) of *nupC* target identified [Expected: ~498 bp]
kefC | Length (bp) of *kefC* target identified [Expected: ~238 bp]
rmuC | Length (bp) of *rmuC* target identified [Expected: ~353 bp]
prophage | Length (bp) of the prophage marker target identified [Expected: ~822 bp]
sbmA | Length (bp) of *sbmA* target identified [Expected: ~64 bp]
ybbW | Length (bp) of *ybbW* target identified [Expected: ~194 bp]
parC_E84V | Length (bp) of *parC* E84V target identified [Expected: ~107 bp]

Within the target columns, there are five possible entries:  

Character | Meaning
---------|---------
[*NUM*] | Length (bp) of target (sequence between and including the primer pair)
\* [*NUM*] \* | Length (bp) of target falls outside +/- 5% of the expected length
NA | Not applicable to the typing of the sample (i.e. clade B- and C-associated primer pairs are not relevant for typing of clade A isolates)
NF | Not found; primer pair was not identified or not identified on the same contig 
NT | Non-typable; O-type, H-type, *fimH*-type or clade could not be determined. Could be due to missing target or the presence of multiple conflicting targets.

## Citation
TBD
