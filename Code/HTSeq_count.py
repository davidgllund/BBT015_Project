#!/usr/bin/python3

# This script takes the SAM files generated from the bowtie2 alignment and the GTF gene annotation file that was downloaded from ensembl and generates a count matrix.
# NOTE: This script should be run from the "Intermediate" directory.

import HTSeq
import numpy as np
import sys

# Import the SAM-files for all 6 samples
samSample1 = HTSeq.SAM_Reader("Sam_files/Sample1.sam")
samSample2 = HTSeq.SAM_Reader("Sam_files/Sample2.sam")
samSample3 = HTSeq.SAM_Reader("Sam_files/Sample3.sam")
samSample4 = HTSeq.SAM_Reader("Sam_files/Sample4.sam")
samSample5 = HTSeq.SAM_Reader("Sam_files/Sample5.sam")
samSample6 = HTSeq.SAM_Reader("Sam_files/Sample6.sam")

# Import the GTF annotation file
geneAnnotation = HTSeq.GFF_Reader("../Data/Reference_data/GeneAnnotation.gtf.gz")

# Generate an array containing the annotated exons. Since the reads are strand specific the argument 'stranded = True' is used
exons = HTSeq.GenomicArrayOfSets("auto", stranded = True)

for feature in geneAnnotation:
    if feature.type == "exon":
        exons[feature.iv] += feature.name

# Find the intersections of all overlapping exons
    iset = None
    for iv2, step_set in exons[feature.iv].steps():
        if iset is None:
            iset = step_set.copy()
        else:
            iset.intersection_update(step_set)

# Go through all of the reads, and, if it contains a single gene name, add a count for that gene
counts = {}
for feature in geneAnnotation:
    if feature.type == "exon":
        counts[feature.name] = 0

# Function that, given a SAM-file, counts the reads and returns a vector of gene counts for the corresponding sample
def count_reads(sam_file):
    for alnmt in sam_file:
        if alnmt.aligned:
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
countVector1 = count_reads(samSample1)
countVector2 = count_reads(samSample2)
countVector3 = count_reads(samSample3)
countVector4 = count_reads(samSample4)
countVector5 = count_reads(samSample5)
countVector6 = count_reads(samSample6)

# Generate the count matrix by concatenating the vectors
countMatrix = np.concatenate((countVector1, countVector2), axis = 1)
countMatrix = np.concatenate((countMatrix, countVector3), axis = 1)
countMatrix = np.concatenate((countMatrix, countVector4), axis = 1)
countMatrix = np.concatenate((countMatrix, countVector5), axis = 1)
countMatrix = np.concatenate((countMatrix, countVector6), axis = 1)

# Also generate a list of gene names
geneNames = []

for name in sorted(counts.keys()):
    geneNames.append(name)

# Export count matrix
stringToExport = ""

for row in countMatrix:
    for column in row:
        stringToExport += str(column) + '\t'

    stringToExport += '\n'

fileName = "countMatrix.tsv"

# Check if successfully exported
try:
    fp = open(fileName, "w")
    fp.write(stringToExport)
    fp.close()
except IOError:
    print("Could not open countMatrix.tsv")
    sys.exit(1)

# Export list of gene names
stringToExport = ""

for row in geneNames:
    stringToExport += str(row) + '\n'

fileName = "geneNames.tsv"

# Check if successfully exported
try:
    fp = open(fileName, "w")
    fp.write(stringToExport)
    fp.close()
except IOError:
    print("Could not open geneNames.tsv")
    sys.exit(1)
