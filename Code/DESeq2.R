#---------- get the data
URL1<- "https://raw.githubusercontent.com/davidgllund/BBT015_Project/master/Intermediate/countMatrix.tsv"
URL2<- "https://raw.githubusercontent.com/davidgllund/BBT015_Project/master/Intermediate/geneNames.tsv"
download.file(URL1, "countMatrix.tsv")
download.file(URL2, "geneNames.tsv")
#---------- Organize Matrix
CountMatrix<-read.table("countMatrix.tsv")
GeneNames <-read.table("geneNames.tsv")
rownames(CountMatrix)<- t(GeneNames)

Condition <-c('control','control','control','knockout','knockout','knockout') # sample conditions as a vector
coldata <-as.data.frame(Condition) # Because DESeqDataSetFromMatrix() wants it as a data frame

#---------------Make DESeq data frame
library("DESeq2")
DESeqData<-DESeqDataSetFromMatrix(CountMatrix, coldata, ~ Condition)

#---------------filter
dds <- DESeqData[rowSums(counts(DESeqData)) >=10,] #keep genes with more counts than 10 (can be adjusted or removed)

#--------------- Run DESeq
dds <- DESeq(dds,test="Wald") # test=wald because that was specified in the article
res <- results(dds) 

#-------------- Extract the relevant stuff
#Build vector of adjusted p-value, log fold change and rownames (gene names)
padj=as.vector(res$padj)
names=as.vector(rownames(res)) #put names in a vector
LFC=as.vector(res$log2FoldChange)
#Create pretty matrix
Results=cbind(LFC,padj)
rownames(Results)<- names
colnames(Results)<- c('LFC', 'Padj')

#Filter to exclude NA (if present) and high p-values (article used 0.05 as cut-off)
Results=Results[!is.na(padj) & Results[,2]<0.05,]

#Sort by increasing p-values
Results.sorted=Results[order((Results[,2])),]
View(Results.sorted)

#Upregulated vs downregulated
LFC.Down=Results.sorted[Results.sorted[,1]<0,]
LFC.UP=Results.sorted[!Results.sorted[,1]<0,]
