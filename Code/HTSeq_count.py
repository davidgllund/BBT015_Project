#!/usr/bin/python3

import HTSeq
import numpy

# Import the SAM-files for all 6 samples
SAM_Sample1 = HTSeq.SAM_Reader("Intermediate/Sample1.sam")
SAM_Sample2 = HTSeq.SAM_Reader("Intermediate/Sample2.sam")
SAM_Sample3 = HTSeq.SAM_Reader("Intermediate/Sample3.sam")
SAM_Sample4 = HTSeq.SAM_Reader("Intermediate/Sample4.sam")
SAM_Sample5 = HTSeq.SAM_Reader("Intermediate/Sample5.sam")
SAM_Sample6 = HTSeq.SAM_Reader("Intermediate/Sample6.sam")

# Import the GTF annotation file
GTF_File = HTSeq.GFF_Reader("Data/Gene_annotation.gtf.gz")

# Generate an array containing the annotated exons. Since the reads are strand specific the argument 'stranded = True' is used
exons = HTSeq.GenomicArrayOfSets("auto", stranded = True)

for feature in GTF_File:
    if feature.type == "exon":
        exons[feature.iv] += feature.name

# Find the intersections of all overlapping exons
iset = None
for iv2, step_set in exons[iv].steps():
    if iset is None:
        iset = step_set.copy()
    else:
        iset.intersection_update(step_set)

# Function that, given a SAM-file, counts the reads and returns a vector of gene counts for that sample
def count_reads(SAM_file):
# Go through all the reads, and, if it contains a single gene name, add a count for that gene
    counts = {}
    for feature in GTF_File:
        if feature.type == "exon":
            counts[feature.name] = 0

# Count the reads in the SAM-file
    for alnmt in SAM_file:
        iset = None
        for iv2, step_set in exons[alnmt.iv].steps():
            if iset is None:
                iset = step_set.copy()
            else:
                iset.intersection_update(step_set)
        if len(iset) == 1:
            counts[list(iset)[0]] += 1

# Initialize count vector as empty list 
    countVector = []

# Fill the list with the counts of all genes
    for name in sorted(counts.keys()):
        countVector.append(counts[name])

# Convert the list to a Numpy array
    countVector = np.array(countVector)

# Convert array to correct format
    countVector = countVector.reshape(len(counts), 1)
    return countVector

# Use the function to generate count vectors for all samples
countVector1 = count_reads(SAM_Sample1)
countVector2 = count_reads(SAM_Sample2)
countVector3 = count_reads(SAM_Sample3)
countVector4 = count_reads(SAM_Sample4)
countVector5 = count_reads(SAM_Sample5)
countVector6 = count_reads(SAM_Sample6)

# Generate the count matrix by concatenating the vectors
countMatrix = np.concatenate((countVector1, countVector2), axis = 1)

for i in range(3,7):
    countMatrix = np.concatenate((countMatrix, countVectori), axis = 1)

# Also generate a list of gene names
geneNames = []

for name in sorted(counts.keys()):
    geneNames.append(name)
