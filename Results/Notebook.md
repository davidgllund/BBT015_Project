# About

This is a notebook that in chronological order contains descriptions of the results that were obtained from performed experiments. In addition it also contains relevant reflections about every experiment, such as ideas about why the expected result was not yielded by the analysis.

Every entry should include information about when the experient was performed and by whom, as well as where the relevant figure/table/etc can be found (file name and sub-directory).

## 2019-03-03 David Lund

The primary results achieved by running Alingment.sh, HTSeq_count.py and DESeq2.R found 943 significant differentially expressed genes. Compared to the article, which found 972 significant differentially expressed genes, this number is relatively close but not exact. THough it is difficult to know where in the analysis the fault lies, I am interested in further investigating the results of the HTSeq_count.py script. The reason for this is that I wrote the code without being familiar with the package before, and therefore I might have made some mistake.

I have found out that there is a command called 'htseq-count' that can be used from the command line to automatically count the reads from a file. I plan to write a shell script that uses this function as a black box and then comparing the results to those generated from the script i manually wrote.
