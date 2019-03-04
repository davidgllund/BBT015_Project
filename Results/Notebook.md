# About

This is a notebook that in chronological order contains descriptions of the results that were obtained from performed experiments. In addition it also contains relevant reflections about every experiment, such as ideas about why the expected result was not yielded by the analysis.

Every entry should include information about when the experient was performed and by whom, as well as where the relevant figure/table/etc can be found (file name and sub-directory).

## 2019-03-03 David Lund

The primary results achieved by running Alingment.sh, HTSeq_count.py and DESeq2.R found 943 significant differentially expressed genes. Compared to the article, which found 972 significant differentially expressed genes, this number is relatively close but not exact. Though it is difficult to know where in the analysis the fault lies, I am interested in further investigating the results of the HTSeq_count.py script. The reason for this is that I wrote the code without being familiar with the package beforehand, and therefore I might have made some mistake.

I have found out that there is a command called 'htseq-count' that can be used from the command line to automatically count the reads from a file. I plan to write a shell script that uses this function as a black box and then comparing the results to those generated from the script i manually wrote.

## 2019-03-04 David Lund

The table below displays the top 10 most significant genes found by the differential expression analysis in the original study, alongside those found by our analysis for two cases where different count matrices were used.

| **Original study** | **HTSEQ_count.py** | **HTSeq_count_auto.sh** |
|:------------------:|:------------------:|:-----------------------:|
| MT3220.2           | MT3220.2           | MT3220.2                |
| MT3401             | MT3401             | MT3401                  |
| MT1161             | MT1661             | MT1661                  |
| MT3221             | MT3221             | MT3221                  |
| MT3223             | MT1656             | MT1656                  |
| MT1656             | MT1162             | MT3223                  |
| MT3216             | MT3229             | MT1662                  |
| MT3229             | MT3217             | MT3718                  |
| MT3718             | MT2129             | MT3229                  |
| MT3217             | MT3212             | MT3217                  |

By using the count matrix produced by the "black box" script HTSeq_count_auto.sh, 1041 genes where found significant in the differential expression analysis. This means that compared to the 972 genes found in the article and the 943 genes found by using the count matrix generated from HTSeq_count.py, the use of this new count matrix makes the number of significant genes deviate more from the original study.

This could be taken as that the original approach was closer to what was used by the authors, however by inspecting which genes are the top 10 most significant it can be seen that the genes on this list most closely resembles the original study when the black box was used. The conclusion that can be drawn from this is that while there are many similarties betwee results of the original study and the reproduction attempt, the way the count matrix was generated has an effect on the result. None of the ways used in the reproduction attempt are correct, most likely the authors wrote a manual HTSeq script with settings that were not described clearly in the paper.
