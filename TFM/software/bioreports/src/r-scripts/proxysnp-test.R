#SNPRelates test
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
#workingDirectory = 'C:/Users/inclusite/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())


#install.packages("devtools")
#devtools::install_github("slowkow/proxysnps")

library(proxysnps)

f <- function(input, output) {
  d <- get_proxies(query = input[[1]])
  aux <- output[!d$ID,]
  output <-  rbind(output, aux)
}

#rs429358 (19:44908684)
#d <- get_proxies(query = "rs429358")
#d <- get_proxies(chrom = "11", pos = 44908684)

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/20180416200548-disease-7210.23andme.5592-no-mt.csv'
rawData <- read.csv(file=test_upload, header=FALSE, sep=" ", stringsAsFactors = FALSE)

# get only chr1 snps
chr1_data <- rawData[rawData$V2 == 1,]

rsids.pruned <- data.frame(V1=character(),
                           V2=integer(), 
                           V3=integer(),
                           V4=character(),
                           stringsAsFactors = FALSE)

for(i in chr1_data[1:10, ]){
    
  d <- get_proxies(query = chr1_data$V1[[1]])
  if(!(d[d$CHOSEN,]$ID[[1]] %in% rsids.pruned$V1)){
   
    d <- d[!d$CHOSEN,]
    aux <- chr1_data[chr1_data$V1 %in% d$ID,]
    rsids.pruned <-  rbind(rsids.pruned, aux)
    
  }
}

#apply(chr1_data[1:10, ], 1, f, output = rsids.pruned)


