# ST131Typer: *in silico* PCR command line tool for typing *Escherichia coli* ST131

`ST131Typer` is a simple Bash shell script that utilizes the [SeqKit](https://bioinf.shenwei.me/seqkit/) function `seqkit amplicon` to detect *Escherichia coli* sequence type (ST) 131 and characterize its key subclones from whole genome sequence assemblies. This tool targets distinctive nucleotide polymorphisms or sequences in *mdh36*, *gyrB47*, *trpA72*, *sbmA*, *plsB*, *nupC*, *rmuC*, *kefC*, *ybbW*, the O16 and O25b *rfb* variants, five key *fimH* alleles (*fimH22*, *fimH27*, *fimH30*, *fimH35*, and *fimH41*), two *fliC* alleles (H4 and H5), a (subclone-specific) fluoroquinolone resistance-associated *parC* allele, and a (subclone-specific) prophage marker. Collectively, the resulting amplicons allow resolution of 15 distinctive molecular subsets within ST131, including 3 within ST131 clade A (or the H41 subclone), 5 within clade B (or the H22 subclone), and 7 within clade C (or the H30 subclone), which includes subclones C0 (or H30S: 2 subsets), C1 and C1-M27 (or H30R1: 2 subsets), and C2 (or H30Rx: 3 subsets).



NOTE: This works as well as your assembly...

## Requirements

* [SeqKit](https://bioinf.shenwei.me/seqkit/) (>= v0.14.0) plus all dependencies



## Installation

### Check installation


## Usage

### Input Requirements
### Command line options
### Output

## Citation
TBD

## Contributors
ELizabeth Miller (millere@umn.edu)
