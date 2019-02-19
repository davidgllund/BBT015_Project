# BBT015 Project

## Description

This project is a part of the course BBT015 Advanced Bioinformatics, to reproduce a published bioinformatic study. The chosen paper is named *Deficiency of the Novel Exopolyphosphatase Rv1026/PPX2 Leads to Metabolic Downshift and Altered Cell Wall Permeability in Mycobacterium tuberculosis* [1]. 

The paper focuses on the effects accumulation of polyphosphate has on growth and stress tolerance in *Mycobacterium tuberculosis*. The RNA-seq analysis described in the paper characterized differential gene expression of a mutant *M. tubercolosis* where the gene *Rv1026 (ppx2)* (which has hydrolytic activity against long-chain poly(P)) had been knocked down relative to *M. tuberculosis* where the gene had not been knocked down. 

Three samples from each group were analyzed and 972 genes were identified as significantly differentially expressed. Therefore, in order to reproduce the results the concrete goal of the project is to identify these same 972 significant genes.

## Structure

The contents of the different directories are summarized below. Each directory also contains a README.md file that describes its contents in more detail.

* **Code:** Code that can be used to replicate the results of the paper.
* **Data:** Data from samples and reference genome. 
* **Doc:** Documentation about the project, including the final report.
* **Intermediate:** Files that are produced by the analysis, but are not direct results.
* **Results:** Tables and figures that are produced by the analyis.
* **Scratch:** Files that can be safely deleted. 

## References

1. Chuang Y, Bandyopadhyay N, Rifat D, Rubin H, Bader JS, Karakousis PC. 2015. Deficiency of the Novel Exopolyphosphatase Rv1026/PPX2 Leads to Metabolic Downshift and Altered Cell Wall Permeability in *Mycobacterium tuberculosis*. mBio 6(2):e02428-14. doi:10.1128/mBio.02428-14.
