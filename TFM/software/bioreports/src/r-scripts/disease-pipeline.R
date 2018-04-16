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
# script con funciones de consulta a entrez
source("dbSNP.R")
source("utils.R")

args = commandArgs(trailingOnly=TRUE)
# Quotes can be suppressed in the output
print(args[1], quote = FALSE)
print(args[2], quote = FALSE)

fileToRead <- args[1]
fileToWrite <- args[2]
fileToReport <- args[3]

etlRes <- etl(fileToRead = fileToRead, fileToWrite = fileToWrite)
if(etlRes){
  rawData <- read.csv(file=fileToWrite, header=TRUE, sep=" ")
  tuple_df <- cbind(rawData[,2], rawData[,3])
  colnames(tuple_df) <- c("chr_id", "chr_pos")
  
  #create empty dataframe https://stackoverflow.com/questions/10689055/create-an-empty-data-frame
  data_df <- data.frame(snp_id=character(),
                        allele_origin=character(), 
                        clinical_significance=character(),
                        gene_name=character(),
                        chrpos=character(),
                        clinical_significance=character(),
                        diseases=character(),
                        stringsAsFactors=FALSE)
  
  total_rows <- nrow(tuple_df)
  for(i in 0:total_rows){
    chr <- tuple_df[i,][[1]]
    pos <- tuple_df[i,][[2]]
    cat(sprintf('PROCESSING %s of %s: %s:%s \n', i, total_rows, chr, pos))
    if(!is.na(chr)){
      subdata_df <- disease_data_from_snp(chr, pos)
      if(!is.null(subdata_df)){
        data_df <- rbind(data_df, subdata_df)     
      }
    }  
  }
  # pass data to nodeJS
  data_df
  #save into reports folder
  write.csv(data_df, file = fileToReport,row.names=FALSE, na = '')
}
