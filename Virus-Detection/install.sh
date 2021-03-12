#!/bin/bash

#Flag 1 is the number of cores
core=$1

#Download FastQC, RNAfold and index genome hg38
snakemake --cores $core src/FastQC src/ORFfinder src/ViennaRNA-2.4.17/src/bin
snakemake --cores $core src/hg38.fa
