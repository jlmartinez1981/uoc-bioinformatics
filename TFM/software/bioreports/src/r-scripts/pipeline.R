# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
#remove(etl)
#Rscript --vanilla pipeline.R 'C:\Users\jlmartinez\bioreports\upload\test.txt' 'C:\Users\jlmartinez\bioreports\upload_processed\test.txt'
# Quotes can be suppressed in the output
if(!exists("etl", mode="function")){
  source("etl.R")
} 

args = commandArgs(trailingOnly=TRUE)

print(args[1], quote = FALSE)
print(args[2], quote = FALSE)

fileToRead <- args[1]
fileToWrite <- args[2]

etlRes <- etl(fileToRead = fileToRead, fileToWrite = fileToWrite)
etlRes

if(etlRes){
  
}