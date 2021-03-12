#!/bin/bash

#Input 1 is the number of cores
core=$1

#Flag -c is the number of cores
verbose='false'
core=16

while getopts 'c:v' flag; do
  case "${flag}" in
    c) core="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

echo $core

#Download FastQC, RNAfold and index genome hg38
snakemake --cores $core src/FastQC src/ORFfinder src/ViennaRNA-2.4.17/src/bin
snakemake --cores $core src/hg38.fa
