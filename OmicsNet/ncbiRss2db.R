## ----dependencies--------------------------------------------------------
package = function(p) {
	if (!p %in% installed.packages()){ install.packages(p) }
	require(p, character.only=TRUE)
}
package("XML")
package("tm")
# http://www.r-bloggers.com/how-to-download-complete-xml-records-from-pubmed-and-extract-data/

## ----setup---------------------------------------------------------------
workdir="/Users/sunitj/Github/sandbox/OmicsNet"
setwd(workdir)

## ----xml-----------------------------------------------------------------
library(XML)
xml.file="data/pubmed_allTime_search.xml"

# Parse XML into XML Tree
xml.data = xmlTreeParse(xml.file, useInternalNodes = TRUE)
top=xmlRoot(xml.data)
abstracts=xpathApply(top,"//Abstract/AbstractText", xmlValue)
abstract.words=paste(abstracts, collapse = " ")

## ------------------------------------------------------------------------
library(tm)
abstract.words = VectorSource(abstract.words)
corpus = Corpus(abstract.words)
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, stripWhitespace)
corpus = tm_map(corpus, removeWords, stopwords("english"))

## ------------------------------------------------------------------------
# Use xpathSApply to extract Journal name
# journal = sapply(c("//AuthorList//Author//LastName", "//ISOAbbreviation"), xpathApply, doc = xml.data, fun = xmlValue)
# df = data.frame(unlist(journal))
library(SnowballC)   
docs = tm_map(corpus, stemDocument)
docs = tm_map(docs, PlainTextDocument) 
dtm <- DocumentTermMatrix(docs)
freq <- colSums(as.matrix(dtm))   
length(freq) 

ord <- order(freq) 
m <- as.matrix(dtm)   
 dim(m)   
  write.csv(m, file="dtm.csv", sep="\t", quote=F)  
  dtms <- removeSparseTerms(dtm, 0.1)
  wf <- data.frame(word=names(freq), freq=freq)  
  write.table(wf, "word_freq.tsv", sep="\t", quote=F)
