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

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload.txt'
rawData <- read.csv(file=test_upload, header=TRUE, sep=" ", stringsAsFactors = FALSE)

tuple_df <- cbind(rawData[,2], rawData[,3])
colnames(tuple_df) <- c("chr_id", "chr_pos")

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
#(rs237025, 6:149400554), other, risk factor in clinvar
#(rs4477212, 1:82154), non pathogenic
#(rs429358, 19:44908684), pathogenic
#(rs4986791, 9:117713324) untested
#(rs8067378, 17:39895095) non clinvar results
#(rs1695, 11:67585218) 9 snp results, drug-response

tuple_df <- cbind(c(9,1,19,9,17,11),
                  c(117713024,82154, 44908684,117713324,39895095,67585218))

tuple_df <- cbind(c(6,19),
                  c(149400554, 44908684))
colnames(tuple_df) <- c("chr_id", "chr_pos")

for(i in 1:nrow(tuple_df)){
  chr <- tuple_df[i,][[1]]
  pos <- tuple_df[i,][[2]]
  cat(sprintf('PROCESSING: %s:%s \n', chr, pos))
  if(!is.na(chr)){
    subdata_df <- disease_data_from_snp(chr, pos)
    if(!is.null(subdata_df)){
      data_df <- rbind(data_df, subdata_df)     
    }
  }  
}
data_df

# TODO save into reports folder
fileToReport <- 'C:/Users/jlmartinez/bioreports/reports/test.csv'
# http://rprogramming.net/write-csv-in-r/
cat(sprintf('SAVING REPORT TO: %s \n', fileToReport))
write.csv(data_df, file = fileToReport,row.names=FALSE)
