# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())

#Rscript --vanilla pipeline.R 'C:\Users\jlmartinez\bioreports\upload\test.txt' 'C:\Users\jlmartinez\bioreports\upload_processed\test.txt'
# Quotes can be suppressed in the output
if(!exists("etl", mode="function")){
  source("etl.R")
}
source("utils.R")

args = commandArgs(trailingOnly=TRUE)

print(args[1], quote = FALSE)
print(args[2], quote = FALSE)

fileToRead <- args[1]
fileToRead <- 'C:/Users/jlmartinez/bioreports/upload/test.txt'
fileToWrite <- args[2]
fileToWrite <- 'C:/Users/jlmartinez/bioreports/upload_processed/test.csv'
etlRes <- etl(fileToRead = fileToRead, fileToWrite = fileToWrite)
etlRes

if(etlRes){
  rawData <- read.csv(file=fileToWrite, header=TRUE, sep=" ")
  # 1 = rows 2 = columns
  chrPos <- apply(rawData, 1, extractChrPos)
  print(chrPos)
  rsId <- apply(rawData, 1, extractRsId)
  print(rsId)
}
