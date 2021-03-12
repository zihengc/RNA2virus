# Virus-Detection
Detect virus (known and novel) from human RNA-seq data.

## Authors
* Ziheng Chen (zihengc)
* Yian Liao (yian-liao)
* Aidan Place (aidanjplace)
* Yizhou Wang (yizhou0201)

## Installation

#### Install Snakemake via Conda
Follow Snakemake's instruction on [Installation via Conda](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html#installation-via-conda). Make sure to have the Miniconda Python3 distribution installed as instructed, because this will handle all the software dependencies. 

#### Download and `cd` into this repository 
Download a local copy of this repository via
```
git clone https://github.com/CMU-03713/Viral2.git
```
Then `cd` into the `Virus-Detection` repository via
```
cd Viral2/Virus-Detection
```
All the following work should be done in this repository.

## Required input files
Before running the pipeline, please have the following files donwloaded and put into the repository:
* Reference human genome annotation gtf file: Required for STAR to build human genome index. We recommend downloading the NCBI RefSeq GTF file through UCSC genome browser via
```
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz'
gunzip hg38.ncbiRefSeq.gtf.gz
```
* RNA-seq fastq files: These are the files from which you want to detect viral sequences. Download the RNA-seq fastq files into the `data` folder in this repository. If your file is single end reads, make sure it is named `sample_r1.fastq`, where `sample` is your SRA number. If your file is paired end reads, make sure you have two files `sample_r1.fastq` and `sample_r2.fastq`.

## Configure the workflow

#### Edit the config.yaml
Edit the `config.yaml` according to the instructions in it.


## Run the workflow
1. First, activate Snakemake via
```
conda activate snakemake
```
2. Then run `install.sh` to install the necessary softwares and build a human genome index via
```
vim config.yaml # add the GTF file directory and change the output directory of STAR hg38 genome index.
bash install.sh {cores}
```
replacing `{cores}` with the number of cores you have available.
In this step, we need to build a human genome index, which requires a RAM of at least 40GB. If your available RAM is less than 40GB, this step may fail or be killed. This step is expected to take a long time to run as well. As a reference, it takes around 30 minutes to run on a interactive RM node on psc bridges-2 with 16 cores.

3. If you have single reads data, run the pipeline for single reads data via
```
vim config.yaml # confirm genomeDir is the directory of STAR hg38 genome index. No need to change if the hg38 genome index is built from install.sh.
bash master.sh SE {cores} {sample_r1} 
```
replacing `{cores}` with the number of cores you have available, replaccing `{sample_r1}` with the name of your fastq RNA-seq file, but without the `.fastq` extension. At this step, sample fastq file should be in `/data` and named as `sample_r1.fastq`.

4. If you have paired end reads data, run the pipeline for paired end reads data via
```
vim config.yaml # confirm genomeDir is the directory of STAR hg38 genome index. No need to change if the hg38 genome index is built from install.sh.
bash master.sh PE {cores} {sample} 
```
replacing `{cores}` with the number of cores you have available, replaccing `{sample}` with the name of your sample RNA-seq. At this step, sample fastq files should be in `/data` and named as `sample_r1.fastq` and `sample_r2.fastq`.

## Output files description
All of output file for single read `sample_r1.fastq` or paired end `sample_r1.fastq` and `sample_r2.fastq` will be put into a directory with the same name of your sample, inside the `Virus-Detection` folder. Inside this folder, there will be the following:
1. Trimmed sequences of the raw sequencing files named `_trimmed.fasta` in `/trimmed_fastq` directory.
2. Quality control of the raw sequence data named `_fastqc.html` and `_fastqc.zip` in `/fastqc_report` directory.
3. RNA-seq alignment to human genome named `Aligned.out.sam` in `/star_aligned` directory.
4. A summary of the RNA-seq alignment to human genome named `Log.final.out` in `/star_aligned` directory.
(for more information related to STAR output in the `/star_aligned` directory, refer [STAR User Manual](https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf))
6. RNA-seq reads unmapped to human genome in bam format named `aligned_unmapped.bam` in `/star_unmapped` directory.
7. RNA-seq reads unmapped to human genome in fastq format. `aligned_unmapped.fq` for single read data, or `aligned_unmapped1.fq` and `aligned_unmapped2.fq` for paired end data in `/star_unmapped` directory.
8. Assembled contigs named `final.contigs.fa` in `/assembled_contigs` directory.
9. BLAST report named `blast_out.txt` in `/blast_result` directory.
10. Open Reading Frame report named `contigsWithOrf.fasta` in `/ORFfinder` directory.
11. Secondary RNA strunctures named `secondary_structure.str` in `/RNAfold` directory.
