# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())

#Rscript --vanilla pipeline.R 'C:\Users\jlmartinez\bioreports\upload\test.txt' 'C:\Users\jlmartinez\bioreports\upload_processed\test.txt'
# script con procesos de transformación de datos
if(!exists("ancestry_from_snp_file", mode="function")){
  source("admixture-ancestry.R")
}

args = commandArgs(trailingOnly=TRUE)
# Quotes can be suppressed in the output
print(args[1], quote = FALSE)
print(args[2], quote = FALSE)

fileToRead <- args[1]
fileToWrite <- args[2]
fileToReport <- args[3]

etlRes <- etl(fileToRead = fileToRead, fileToWrite = fileToWrite)
if(etlRes){
  ancestry_data <- ancestry_from_snp_file(path_to_file=fileToWrite)
  
  # pass data to nodeJS
  ancestry_data
  #save into reports folder
  write.csv(ancestry_data, file = fileToReport,row.names=FALSE, na = '')
}
