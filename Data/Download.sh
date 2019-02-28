#!/bin/bash

# This script downloads and decompresses the relevant data for the project.
# This includes 6 sample FASTQ-files and the reference genome.
# Note that it is important to be in the Data directory when running this script.

# Make sure there is a Sample_data subdirectory present
if [ ! -d "Sample_data" ]; then
    echo "Sample_data directory created"
    mkdir Sample_data
fi

# Change directory for downloading sample data
cd Sample_data

# Function that will download a data file, unless it has already been downloaded earlier.
# Input 1: File name of type "SampleX.fastq.gz"
# Input 2: Link to the data
# Input 3: Original file name
# Input 4: Sample number 

download_data ()
{
    if [ -f $1 ]; then
	echo "Sample $4 already exists"
    else
	echo "Downloading Sample $4"
	wget --quiet $2
	# Rename the file
	mv $3 ./"$1"
	# Data should be read only
	chmod 444 $1
    fi

}

# Use the function to download each sample, and then decompress the data:
# Sample 1
download_data "Sample1.fastq.gz" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/005/SRR1294205/SRR1294205.fastq.gz "SRR1294205.fastq.gz" 1

# Sample 2
download_data "Sample2.fastq.gz" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/006/SRR1294206/SRR1294206.fastq.gz "SRR1294206.fastq.gz" 2

# Sample 3
download_data "Sample3.fastq.gz" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/007/SRR1294207/SRR1294207.fastq.gz "SRR1294207.fastq.gz" 3

# Sample 4
download_data "Sample4.fastq.gz" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/008/SRR1294208/SRR1294208.fastq.gz "SRR1294208.fastq.gz" 4

# Sample 5
download_data "Sample5.fastq.gz" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/009/SRR1294209/SRR1294209.fastq.gz "SRR1294209.fastq.gz" 5

# Sample 6
download_data "Sample6.fastq.gz" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/000/SRR1294210/SRR1294210.fastq.gz "SRR1294210.fastq.gz" 6

# Move out of the Sample_data directory to download refernce genome
echo "All samples present in the current directory"
cd ..

# Make sure there is a Reference_genome subdirectory present
if [ ! -d "Reference_data" ]; then                                                           
     echo "Reference_data directory created"     
     mkdir Reference_data      
fi                 

# Change subdirectory and download the reference genome for Mycobacterium tuberculosis CDC1551 from Ensembl
cd Reference_data
wget ftp://ftp.ensemblgenomes.org/pub/release-42/bacteria//fasta/bacteria_6_collection/mycobacterium_tuberculosis_cdc1551/dna/Mycobacterium_tuberculosis_cdc1551.ASM858v1.dna.chromosome.Chromosome.fa.gz
mv Mycobacterium_tuberculosis_cdc1551.ASM858v1.dna.chromosome.Chromosome.fa.gz Reference_genome.fa.gz

# Download gene annotation GTF-file for Mycobacterium tuberculosis from Ensembl
wget ftp://ftp.ensemblgenomes.org/pub/release-42/bacteria//gtf/bacteria_6_collection/mycobacterium_tuberculosis_cdc1551/Mycobacterium_tuberculosis_cdc1551.ASM858v1.42.gtf.gz
mv Mycobacterium_tuberculosis_cdc1551.ASM858v1.42.gtf.gz Gene_annotation.gtf.gz
