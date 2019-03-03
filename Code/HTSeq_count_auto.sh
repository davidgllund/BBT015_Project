#!/bin/bash

# Script that counts the reads in the SAM-files by using htseq-count, and returns the counts for each gene in the used gene annotation file.
# The idea is to use this script as a black box, and to compare the results with those generated manually from HTSeq_count.py 
# NOTE: This script should be run from the "Intermediate" directory

# Make sure an appropriate directory exists for the counts to be stored in
if [ ! -d "Count_data" ]; then
    echo "Count_data directory created"
    mkdir Count_data
fi

# Change directory
cd Sam_files

# Function that applies the pre-existing htseq-count script to count the reads in the samples. Only the actual gene counts are left, excess information such as gene names are removed
# Input 1: Name of the SAM-file that will be counted
# Input 2: Name of the GTF annotation file that will be used
# Input 3: Number associated with the sample, from 1-6

apply_htseq ()
{
    if [ -f $3 ]; then
	echo "$3 already exists, move on to next sample"
    else
	echo "Counting reads for Sample $3"
	htseq-count $1 ../../Data/Reference_data/$2 | grep -v __no_feature | grep -v __ambiguous | grep -v __too_low_aQual | grep -v __not_aligned | grep -v __alignment_not_unique | cut -f 2 > ../Count_data/Sample$3Counts.tsv
    fi

}

# Apply the function to count the reads
# Sample 1
apply_htseq Sample1.sam GeneAnnotation.gtf.gz 1  

# Sample 2
apply_htseq Sample2.sam GeneAnnotation.gtf.gz 2 

# Sample 3
apply_htseq Sample3.sam GeneAnnotation.gtf.gz 3

# Sample 4
apply_htseq Sample4.sam GeneAnnotation.gtf.gz 4

# Sample 5
apply_htseq Sample5.sam GeneAnnotation.gtf.gz 5

# Sample 6
apply_htseq Sample6.sam GeneAnnotation.gtf.gz 6

# Generate a count matrix from the individual count vectors
cd ../Count_data
paste Sample1Counts.tsv Sample2Counts.tsv Sample3Counts.tsv Sample4Counts.tsv Sample5Counts.tsv Sample6Counts.tsv > countMatrixAuto.tsv

# Move the count matrix so that the current directory can be safely deleted
mv countMatrixAuto.tsv ..

# Finish by moving out of the Count_data directory and deleting it (along with its contents)
cd ..
rm -r Count_data
echo "Done"
