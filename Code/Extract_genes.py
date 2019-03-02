#!/usr/bin/env python

import HTSeq
import sys

geneAnnotation = HTSeq.GFF_Reader("../Data/Reference_data/GeneAnnotation.gtf.gz")

print("Extracting gene names")

exons = HTSeq.GenomicArrayOfSets("auto", stranded = True)
counts = {}

for feature in geneAnnotation:
    if feature.type == "exon":
        exons[feature.iv] += feature.name

    iset = None
    for iv2, step_set in exons[feature.iv].steps():
        if iset is None:
            iset = step_set.copy()
        else:
            iset.intersection_update(step_set)

    if feature.type == "exon":
        counts[feature.name] = 0

geneNames = []

for name in sorted(counts.keys()):
     geneNames.append(name)

stringToExport = ""

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
