#!/usr/bin/env python

import HTSeq
import sys

# Import the GTF annotation file
geneAnnotation = HTSeq.GFF_Reader("../Data/Reference_data/GeneAnnotation.gtf.gz")

print("Extracting gene names")

# Generate an array containing the annotated exons, note that reads are strand specific
exons = HTSeq.GenomicArrayOfSets("auto", stranded = True)

# Generate array to hold count data
counts = {}

for feature in geneAnnotation:
    if feature.type == "exon":
        exons[feature.iv] += feature.name

# Find the intersection of all overlapping genes
    iset = None
    for iv2, step_set in exons[feature.iv].steps():
        if iset is None:
            iset = step_set.copy()
        else:
            iset.intersection_update(step_set)

# If the read contains a single gene name, add a count for that gene
    if feature.type == "exon":
        counts[feature.name] = 0

# Generate the list of gene names
geneNames = []

for name in sorted(counts.keys()):
     geneNames.append(name)
     
# Export list of gene names
stringToExport = ""

# Check if successfully exported
for row in geneNames:
    stringToExport += str(row) + '\n'

fileName = "geneNames.tsv"

try:
    fp = open(fileName, "w")
    fp.write(stringToExport)
    fp.close
except IOError:
    print("Could not open geneNames.tsv")
    sys.exit(1)
