#http://bioconductor.org/packages/release/data/experiment/html/hapmapsnp6.html
#http://bioconductor.org/packages/release/data/experiment/manuals/hapmapsnp6/man/hapmapsnp6.pdf
source("https://bioconductor.org/biocLite.R")
biocLite("hapmapsnp6")

library(oligo)
library(hapmapsnp6)
the.path <- system.file("celFiles", package="hapmapsnp6")
cels <- list.celfiles(path=the.path, full.names=TRUE)
temporaryDir <- tempdir()
rawData <- read.celfiles(fullFilenames, tmpdir=temporaryDir)

# data(crlmmResult)

library(SNPassoc)
data(HapMap)

#df[which(df$Amount == min(df$Amount)), ]
