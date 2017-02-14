#!/usr/bin/env Rscript

.libPaths(getwd())
install.packages("getopt", repos="http://lib.stat.cmu.edu/R/CRAN", lib=getwd())
source("http://bioconductor.org/biocLite.R")
biocLite("ballgown")
.libPaths(getwd())

library("getopt")
library("ballgown")
library("genefilter")


#ARGUMENTS
args<-commandArgs(trailingOnly=TRUE)

options<-matrix(c('design', 'd', 1, "character",
                  'covariate', 'o', 1, "character",
                  'datadir', 's',1,"character"),
                   ncol=4, byrow=TRUE)


ret.opts<-getopt(options, args)

designMatrix<-ret.opts$design
pheno_data = read.table(file=designMatrix, header = TRUE, sep = "\t")
covariateType<-ret.opts$covariate
dataDir<-ret.opts$datadir
sample_full_path<-paste(dataDir,pheno_data$ID, sep = '/')
sample_full_path
#setwd(dataDir)
#bg = ballgown(dataDir=dataDir, samplePattern='IS',meas='all',pData = pheno_data )
#bg = ballgown(samples=as.vector(pheno_data$ID),pData=pheno_data)
bg = ballgown(samples=as.vector(sample_full_path),pData=pheno_data)
bg

# Perform DE with no filtering
results_genes = stattest(bg, feature='gene', meas='FPKM', covariate=covariateType, getFC = TRUE)
results_transcripts = stattest(bg, feature='transcript', meas='FPKM', covariate=covariateType, getFC = TRUE)
write.table(results_transcripts,"results_trans.tsv",sep="\t")
write.table(results_genes,"results_gene.tsv",sep="\t")

# Filter low-abundance genes Here we remove all transcripts with a variance across samples less than one
bg_filt = subset (bg,"rowVars(texpr(bg)) > 1", genomesubset=TRUE)
results_transcripts = stattest(bg_filt, feature="transcript", covariate=covariateType, getFC=TRUE, meas="FPKM")
results_genes = stattest(bg_filt, feature="gene", covariate=covariateType, getFC=TRUE, meas="FPKM")
write.table(results_transcripts,"results_trans_filter.tsv",sep="\t")
write.table(results_genes,"results_gene_filter.tsv",sep="\t")

# Identify genes with p value < 0.05
sig_transcripts = subset(results_transcripts,results_transcripts$pval<0.05)
sig_genes = subset(results_genes,results_genes$pval<0.05)
write.table(sig_transcripts,"results_trans_filter.sig.tsv",sep="\t")
write.table(sig_genes,"results_gene_filter.sig.tsv",sep="\t")

#plotting
fpkm=texpr(bg_filt,meas = "FPKM")
fpkm= log2(fpkm+1)
boxplot(fpkm,col=as.numeric(pheno_data$group),las=2,ylab='log2(FPKM+1)')
