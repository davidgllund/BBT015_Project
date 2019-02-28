!/bin/bash

# This script converts the 6 compressed fastq data files into sam-files.
# Current directory should be Data

if [ ! -d ../Intermediate/Fastq_Data ]; then
echo "Intermediate fastq directory created"
mkdir ../Intermediate/Fastq_Data
mkdir ../Intermediate/Fastq_Data/Reference_Fastq_Data
mkdir ../Intermediate/Fastq_Data/Sample_Fastq_Data
fi

#Unzipping files

cd Sample_data

FILES=*.gz
for gz in $FILES; do
echo "unzipping $gz and placing it in Intermediate/Fastq_Data directory " 1>&2
fn=$(basename $gz .gz)
gunzip -c $gz > ../../Intermediate/Fastq_Data/Sample_Fastq_Data/$fn
done

cd ..

echo "unzipping the reference genome and placing it in Intermediate/Fastq_Data directory"
gunzip -c ./Reference_data/ReferenceGenome.fa.gz > ../Intermediate/Fastq_Data/Reference_Fastq_Data/ReferenceGenome.fastq

cd ../Intermediate

if [ ! -d Fasta_Data ]; then
echo "Intermediate fasta directory created"
mkdir Fasta_Data
fi

#Converting fastq reference file to fasta

cd Fasta_Data
seqret -sequence ../Fastq_Data/Reference_Fastq_Data/ReferenceGenome.fastq -feature -fformat gff3 -osformat fasta ./ReferenceGenome.fasta

cd ..

if [ ! -d Reference_index_files ]; then
echo "Directory for reference index files created"
mkdir Reference_index_files
fi

#We need to create an index file for the reference genome

cd Reference_index_files

if [ ! -f ReferenceGenome ]; then
echo "Creating index file for reference genome..."
bowtie2-build -f ../Fasta_Data/ReferenceGenome.fasta ReferenceGenome
fi

#Now align sample data to reference genome

cd ..

if [ ! -d Sam_files ]; then
echo "Directory for sam files created"
mkdir Sam_files
fi

cd Fastq_Data/Sample_Fastq_Data

FILES=*.fastq
for fastq in $FILES; do
echo "aligning $fastq..." 1>&2
fn=$(basename $fastq .fastq)
bowtie2 -x ../../Reference_index_files/ReferenceGenome -U $fn.fastq -S ../../Sam_files/$fn.sam
done

echo "Done" 
