# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/inclusite/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
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

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload.txt'
test_upload <- 'C:/Users/inclusite/bioreports/upload_processed/20180416115748-ancestry-7339.ancestry.5702'
test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/20180416200548-disease-7210.23andme.5592.csv'

rawData <- read.csv(file=test_upload, header=FALSE, sep=" ", stringsAsFactors = FALSE)

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

#obtain data, test with
#(rs4986790, 9:117713024), benign
#(rs237025, 6:149400554), other, risk factor in clinvar
#(rs4477212, 1:82154), non pathogenic
#(rs429358, 19:44908684), pathogenic
#(rs4986791, 9:117713324) untested
#(rs8067378, 17:39895095) non clinvar results
#(rs1695, 11:67585218) 9 snp results, drug-response
#(rs1815739, 11:66560624) 5 snp results, 2 omim results, pathologic (sprint performance)
#(rs6152, X:67545785) 2 snp results, benign

#tuple_df <- cbind(c(9,1,19,9,17,11),
#                  c(117713024,82154, 44908684,117713324,39895095,67585218))

#tuple_df <- cbind(c(6,19,11,'X'),
#                 c(149400554, 44908684,66560624,67545785))
#colnames(tuple_df) <- c("chr_id", "chr_pos")
total_rows <- nrow(tuple_df)
cat(sprintf('PROCESSING DATA FRAME WITH %s ROWS \n',total_rows))
for(i in 1:total_rows){
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
data_df

# TODO save into reports folder
fileToReport <- 'C:/Users/jlmartinez/bioreports/reports/disease/disease-test.csv'
# fileToReport <- 'C:/Users/inclusite/bioreports/reports/disease/test.csv'
# http://rprogramming.net/write-csv-in-r/
cat(sprintf('SAVING REPORT TO: %s \n', fileToReport))
write.csv(data_df, file = fileToReport,row.names=FALSE, na = '')
