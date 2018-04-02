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
# script con funciones de consulta a entrez
source("dbSNP.R")
source("utils.R")

args = commandArgs(trailingOnly=TRUE)
# Quotes can be suppressed in the output
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
  rsIds <- apply(rawData, 1, extractRsId)
  for(rsId in rsIds)
    print(rsId)
  
  #create empty dataframe https://stackoverflow.com/questions/10689055/create-an-empty-data-frame
  data_df <- data.frame(snp_id=character(),
                   allele_origin=character(), 
                   clinical_significance=character(),
                   gene_name=character(),
                   chrpos=character(),
                   diseases=character(),
                   stringsAsFactors=FALSE) 
  
  #obtain data, test with
  #(rs4986790, 9:117713024), benign
  #(rs4477212, 1:82154), non pathogenic
  #(rs429358, 19:44908684), pathogenic
  #(rs4986791, 9:117713324) untested
  #(rs8067378, 17:39895095) non clinvar results
  #(rs1695, 11:67585218) 9 snp results, drug-response
  
  data_df <- rbind(data_df, subdata_df)
  
  
}
