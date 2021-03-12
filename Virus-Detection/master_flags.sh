#!/bin/bash

#Flags: -m is 'PE' for 'pair-ended' or 'SE' for 'single-ended'
#-c is the number of cores; -s is the sequence file.
verbose='false'
mode=''
core=16
sample=''
while getopts 'mcs:v' flag; do
  case "${flag}" in
    m) mode="${OPTARG}" ;;
    c) core="${OPTARG}" ;;
    s) sample="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [ $mode=="SE" ];
then
    cd single_end_pip
    wget https://ftp.ncbi.nlm.nih.gov/blast/db/ref_viruses_rep_genomes.tar.gz
    tar -xzvf ref_viruses_rep_genomes.tar.gz
    snakemake --cores $core ../$sample/star_unmapped/align_unmapped.fq ../$sample/fastqc_report//single_end_trimmed_fastqc.html ../$sample/assembled_contigs
    snakemake --cores $core ../$sample/blast_result/blast_out.txt ../$sample/ORFfinder ../$sample/RNAfold_output/secondary_structure.str

elif [ $mode=="PE" ];
then

    cd paired_end_pip
    wget https://ftp.ncbi.nlm.nih.gov/blast/db/ref_viruses_rep_genomes.tar.gz
    tar -xzvf ref_viruses_rep_genomes.tar.gz
    snakemake --cores $core ../$sample/star_unmapped/align_unmapped.fq ../$sample/fastqc_report/r1_paired_trimmed_fastqc.html \
    ../$sample/fastqc_report/r2_paired_trimmed_fastqc.html ../$sample/assembled_contigs
    snakemake --cores $core ../$sample/blast_result/blast_out.txt ../$sample/ORFfinder ../$sample/RNAfold_output/secondary_structure.str
fi
