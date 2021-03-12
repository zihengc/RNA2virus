configfile: "config.yaml"

rule install_dependencies:
    output:
        "src/ORFfinder",

        "src/Trimmomatic-0.39.zip",
        directory("src/Trimmomatic-0.39"),
        
        directory("src/FastQC")

    shell:
        """
        cd src

        wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
        unzip -o Trimmomatic-0.39.zip

        wget https://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/ORFfinder/linux-i64/ORFfinder.gz
        gzip -d ORFfinder.gz
        chmod +x ORFfinder

        wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
        unzip fastqc_v0.11.9.zip

        wget https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
        tar zvxf MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz

        pip install orfipy
        """

rule install_RNAfold:
    output:
        "src/ViennaRNA-2.4.17.tar.gz",
        directory("src/ViennaRNA-2.4.17/src/bin")
    shell:
        """
        cd src
        wget https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_4_x/ViennaRNA-2.4.17.tar.gz
        tar -xzvf ViennaRNA-2.4.17.tar.gz
        cd ViennaRNA-2.4.17
        ./configure
        make || true
        """

rule index_hg38:
    input:
        gtf=config["gtf"]
    output:
        hg="src/hg38.fa",
        genomeDir=directory({config["genomeDir"]})
    threads:
        config["threads"]
    conda:
        "envs/unmapped.yaml"    
    shell:
        """
        cd src

        wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
        gzip hg38.fa.gz -d
        cd ..
        STAR --runMode genomeGenerate --runThreadN {threads} --genomeDir {output.genomeDir} --genomeFastaFiles src/hg38.fa --sjdbGTFfile {input.gtf} --sjdbOverhang 100
        """
