# ST131Typer: *In silico* PCR command line tool for typing *Escherichia coli* ST131

`ST131Typer` is a simple Bash shell script that utilizes the [SeqKit](https://bioinf.shenwei.me/seqkit/) function `seqkit amplicon` to detect *Escherichia coli* sequence type (ST) 131 and characterize its key subclones from whole genome sequence assemblies.  

This tool is based on the *in vitro* multiplex PCR assays developed by [Johnston et al. *in prep*](), which allows resolution of 15 distinctive molecular subsets within ST131, including 3 within ST131 clade A (or the H41 subclone), 5 within clade B (or the H22 subclone), and 7 within clade C (or the H30 subclone), including subclones C0 (or H30S: 2 subsets), C1 and C1-M27 (or H30R1: 2 subsets), and C2 (or H30Rx: 3 subsets).  

Specifically, this tool targets distinctive nucleotide polymorphisms or sequences in *mdh36*, *gyrB47*, *trpA72*, *sbmA*, *plsB*, *nupC*, *rmuC*, *kefC*, *ybbW*, the O16 and O25b *rfb* variants, five key *fimH* alleles (*fimH22*, *fimH27*, *fimH30*, *fimH35*, and *fimH41*), two *fliC* alleles (H4 and H5), a (subclone-specific) fluoroquinolone resistance-associated *parC* allele, and a (subclone-specific) prophage marker.  


NOTE: This works as well as your assembly...

## Requirements

* [SeqKit](https://bioinf.shenwei.me/seqkit/) (>= v0.14.0) plus all dependencies
    * Go to the SeqKit [Installation Page](https://github.com/shenwei356/seqkit#installation) for install options.
* `primers.txt` file located in the `ST131Typer/data` directory
* `profiles.txt` file located in the `ST131Typer/data` directory

## Installation

`git clone https://github.com/JohnsonSingerLab/ST131Typer.git/`

### Check Installation

Ensure the desired ST131Typer version is installed:

`./ST131Typer.sh -v`

Check that the dependency SeqKit is installed in your path:

`./ST131Typer.sh -c`

## Usage

### Input Requirements

* assembly in FASTA format or directory containing multiple assemblies in FASTA format; assemblies can be in multiple contigs
* directory to put the results in
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
	-b		directory containing primers.txt and profiles.txt
  -r    prints citation
```

### Output





## Citation
TBD

## Contributors
ELizabeth Miller (millere@umn.edu)
