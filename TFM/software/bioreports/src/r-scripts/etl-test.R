# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())

#Rscript --vanilla pipeline.R 'C:\Users\jlmartinez\bioreports\upload\test.txt' 'C:\Users\jlmartinez\bioreports\upload_processed\test.txt'
# script con procesos de transformación de datos
if(!exists("etl", mode="function")){
  source("etl.R")
}
if(!exists("disease_data_from_snp", mode="function")){
  # script con funciones de consulta a entrez
  source("dbSNP.R")
}

#source("utils.R")
fileToRead <- 'C:/Users/jlmartinez/bioreports/upload/test-alelles1.txt'
fileToWrite <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload-alelles1.txt'
etlRes <- etl(fileToRead = fileToRead, fileToWrite = fileToWrite)

fileToRead <- 'C:/Users/jlmartinez/bioreports/upload/test-alelles2.txt'
fileToWrite <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload-alelles2.txt'
etlRes <- etl(fileToRead = fileToRead, fileToWrite = fileToWrite)

fileToRead <- 'C:/Users/jlmartinez/bioreports/upload/test-alelles3.txt'
fileToWrite <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload-alelles3.txt'
etlRes <- etl(fileToRead = fileToRead, fileToWrite = fileToWrite)

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload-alelles1.txt'
rawData1 <- read.csv(file=test_upload, header=TRUE, sep=" ", stringsAsFactors = FALSE)

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload-alelles3.txt'
rawData2 <- read.csv(file=test_upload, header=TRUE, sep=" ", stringsAsFactors = FALSE)

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload-alelles3.txt'
rawData3 <- read.csv(file=test_upload, header=TRUE, sep=" ", stringsAsFactors = FALSE)