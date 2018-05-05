#SNPRelates test
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
#workingDirectory = 'C:/Users/inclusite/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())


#install.packages("devtools")
#devtools::install_github("slowkow/proxysnps")

library(proxysnps)

#rs429358 (19:44908684)
#d <- get_proxies(query = "rs429358")
#d <- get_proxies(chrom = "11", pos = 44908684)

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/20180416200548-disease-7210.23andme.5592-no-mt.csv'
rawData <- read.csv(file=test_upload, header=FALSE, sep=" ", stringsAsFactors = FALSE)

# get only chr1 snps
chr1_data <- rawData[rawData$V2 == 1,]

rsids.ld <- data.frame(V1=character(),
                       V2=integer(), 
                       V3=integer(),
                       V4=character(),
                       stringsAsFactors = FALSE)

f <- function(input, orig) {
  cat(sprintf('GET PROXIES: %s \n', input[[1]]))
  #d <- get_proxies(query = input[[1]])
  d <- tryCatch({exp=get_proxies(query = input[[1]])}, error=function(i){
    cat(sprintf('ERROR: %s \n', i))
    return(NULL)
  })
 
  cat('PRUNNED: ', rsids.ld$V1)
  cat('CHOSEN: ', d[d$CHOSEN,]$ID)
  if(!is.null(d) && !(d[d$CHOSEN,]$ID[[1]] %in% rsids.ld$V1)){
    d <- d[!d$CHOSEN,]
    aux <- orig[orig$V1 %in% d$ID,]
    rsids.ld <<-  rbind(rsids.ld, aux)
  }
}

#kk <- apply(chr1_data[1:10, ], 1, f, orig = chr1_data, output = rsids.pruned)
#kk <- apply(chr1_data[1:3, ], 1, f, orig = chr1_data)

#rsids.pruned2 <- do.call(rbind, kk)
#rsids.pruned2

ld_data_from_proxy_snp <- function (rsid = NULL){
  
  kk <- apply(rsid[1:3, ], 1, f, orig = rsid)
  
}

jj <- ld_data_from_proxy_snp(rsid = chr1_data)
jj


