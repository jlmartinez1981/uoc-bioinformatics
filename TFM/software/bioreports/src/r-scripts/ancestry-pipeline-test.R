# radixture test
library(radmixture)

# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
#workingDirectory = 'C:/Users/inclusite/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())

#Rscript --vanilla pipeline.R 'C:\Users\jlmartinez\bioreports\upload\test.txt' 'C:\Users\jlmartinez\bioreports\upload_processed\test.txt'
# script con procesos de transformaci?n de datos
if(!exists("etl", mode="function")){
  source("etl.R")
}

args = commandArgs(trailingOnly=TRUE)
# Quotes can be suppressed in the output
print(args[1], quote = FALSE)
print(args[2], quote = FALSE)
print(args[3], quote = FALSE)

path_to_file <- 'C:/Users/jlmartinez/bioreports/upload_processed/20180415210238-ancestry-7210.23andme.5592.txt'
genotype <- read.table(file = path_to_file)

load('C:/Users/jlmartinez/Desktop/reference-data/globe13.alleles.RData')
load('C:/Users/jlmartinez/Desktop/reference-data/globe13.13.F.RData')

# Use K13
res <- tfrdpub(genotype, 13, globe13.alleles, globe13.13.F)

# Use K13
ances <- fFixQN(res$g, res$q, res$f, tol = 1e-4, method = "BR", pubdata = "K13")

ances$q

# TODO save into reports folder
fileToReport <- 'C:/Users/jlmartinez/bioreports/reports/ancestry/20180415210238-ancestry-7210.23andme.5592.csv'
# http://rprogramming.net/write-csv-in-r/
cat(sprintf('SAVING REPORT TO: %s \n', fileToReport))
write.csv(ances$q, file = fileToReport,row.names=FALSE, na = '')
