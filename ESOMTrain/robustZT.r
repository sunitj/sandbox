#!/usr/bin/R

# Read the ESOM lrn file and normalize
args = commandArgs(trailingOnly = TRUE)
lrnFile = args[1]

# Sanity Checks
if (lrnFile == "" || is.na(lrnFile) || toupper(lrnFile)=="TEST") lrnFile="data/test.lrn"
if (!file.exists(lrnFile)){
	print(paste("[",lrnFile,"] not found! Exiting...", sep = " "))
	quit(status = 1)
}

# Read the lrn file
library(readr)
lrn=read_tsv(lrnFile,skip = 3,col_names = T)
colnames(lrn)[1]=c("Key")
row.names(lrn)=lrn$Key
lrn=lrn %>% select(-Key)
# Normalize
mad_rzt = function(x){
	x=unlist(x)
	Median=median(x,na.rm = T)
	Mad=mad(x,na.rm = T)
	rzt=(x-Median)/Mad
	return(rzt)
}
zt = function(x){
	x=unlist(x)
	Mean=mean(x)
	SD=sd(x)

	zt=(x-Mean)/SD
	return(zt)
}

library(dplyr)
zt.lrn=mad.lrn=lrn
mad.lrn[]=lapply(mad.lrn,FUN= function(x) mad_rzt(x))
zt.lrn[]=lapply(zt.lrn,FUN= function(x) zt(x))

library(DESeq2)
rlog.lrn=rlog(as.matrix(lrn))
rlog.lrn=as.data.frame(rlog.lrn)

# Compare with ESOM-RZT
esom.rzt.lrnFile="data/esom.rzt.lrn"
esom.rzt.lrn=read_tsv(esom.rzt.lrnFile,skip=3,col_names = T)
colnames(esom.rzt.lrn)[1]=c("Key")
row.names(esom.rzt.lrn)=esom.rzt.lrn$Key
esom.rzt.lrn=select(esom.rzt.lrn,-Key)

library(ggplot2)
for(col.num in seq(1:length(lrn))){
	kmer=aes_string(x=colnames(lrn[col.num]))
	ggplot() +
		geom_freqpoly(data=mad.lrn, kmer, color="green") +
		geom_freqpoly(data=lrn, kmer, color="red") +
		geom_freqpoly(data=esom.rzt.lrn, kmer, color="blue") +
		geom_freqpoly(data=zt.lrn, kmer, color="yellow")
}

