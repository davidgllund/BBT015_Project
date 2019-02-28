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
    fn=$(basename $gz .gz)
    if [ ! -f ../../Intermediate/Fastq_Data/Sample_Fastq_Data/$fn ]; then
	echo "unzipping $gz and placing it in Intermediate/Fastq_Data directory " 1>&2
	gunzip -c $gz > ../../Intermediate/Fastq_Data/Sample_Fastq_Data/$fn;
    else
	echo "Unzipped $gz fastq-file already exists"
    fi
done

cd .. 

if [ ! -f ../Intermediate/Fastq_Data/Reference_Fastq_Data/ReferenceGenome.fastq ]; then
    echo "unzipping the reference genome and placing it in Intermediate/Fastq_Data directory"
    gunzip -c ./Reference_data/ReferenceGenome.fa.gz > ../Intermediate/Fastq_Data/Reference_Fastq_Data/ReferenceGenome.fastq
else
    echo "unzipped reference genome already exists"
fi
   

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
    fn=$(basename $fastq .fastq)
    if [ ! -f ../../Sam_files/$fn.sam ]; then
	echo "aligning $fastq..." 1>&2
	bowtie2 -x ../../Reference_index_files/ReferenceGenome -U $fn.fastq -S ../../Sam_files/$fn.sam
    else
	"sam files already exists"
    fi
done

echo "Done" 
