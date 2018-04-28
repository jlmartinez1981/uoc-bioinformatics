# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
#workingDirectory = 'C:/Users/inclusite/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())

#Rscript --vanilla pipeline.R 'C:\Users\jlmartinez\bioreports\upload\test.txt' 'C:\Users\jlmartinez\bioreports\upload_processed\test.txt'
# script con procesos de transformación de datos
if(!exists("etl", mode="function")){
  source("etl.R")
}
if(!exists("ld_data_from_snp", mode="function")){
  # script con funciones de consulta a entrez
  source("snprelates-LD.R")
}
if(!exists("disease_data_from_snp", mode="function")){
  # script con funciones de consulta a entrez
  source("dbSNP.R")
}

args = commandArgs(trailingOnly=TRUE)
# Quotes can be suppressed in the output
print(args, quote = FALSE)
#print(args[1], quote = FALSE)
#print(args[2], quote = FALSE)
#print(args[3], quote = FALSE)
#print(args[4], quote = FALSE)

#print("bye", quote = FALSE)
#quit()
#print("bye bye", quote = FALSE)

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload.txt'
test_upload <- 'C:/Users/inclusite/bioreports/upload_processed/20180416200548-disease-7210.23andme.5592-chr1.csv'
test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/20180416200548-disease-7210.23andme.5592-no-mt.csv'

rawData <- read.csv(file=test_upload, header=FALSE, sep=" ", stringsAsFactors = FALSE)

#basename(test_upload)
# [1] "a.ext"
#dirname(test_upload)
# [1] "C:/some_dir"
basename(test_upload)
rsids.pruned <- ld_data_from_snp(orig_file = test_upload, transform_file_name = basename(test_upload))

filtered_ld_snps <- rawData[rawData$V1 %in% rsids.pruned,]
#filtered_ld_snps <- rawData

tuple_df <- cbind(filtered_ld_snps[,1], filtered_ld_snps[,2], filtered_ld_snps[,3])
colnames(tuple_df) <- c("rsid", "chr_id", "chr_pos")

#create empty dataframe https://stackoverflow.com/questions/10689055/create-an-empty-data-frame
data_df <- data.frame(snp_id=character(),
                      allele_origin=character(), 
                      clinical_significance=character(),
                      gene_name=character(),
                      chrpos=character(),
                      clinical_significance_clinvar=character(),
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
fileToReport <- 'C:/Users/jlmartinez/bioreports/reports/disease/test.csv'
#fileToReport <- 'C:/Users/inclusite/bioreports/reports/disease/test.csv'
cat(sprintf('SAVING REPORT TO: %s \n', fileToReport))
write.table(data_df, file = fileToReport, row.names=FALSE, col.names = TRUE, na = '', sep = ",", append = FALSE)

for(i in 1:total_rows){
  rsid <- tuple_df[i,][[1]]
  chr <- tuple_df[i,][[2]]
  pos <- tuple_df[i,][[3]]
  cat(sprintf('PROCESSING %s of %s: rsid %s at %s:%s \n', i, total_rows, rsid, chr, pos))
  if(!is.na(chr)){
    subdata_df <- tryCatch({exp=disease_data_from_snp(rsid, chr, pos)}, error=function(i){
      cat(sprintf('ERROR PROCESSING rsid:%s at %s:%s \n', rsid, chr, pos))
      return(NULL)
    })
    if(!is.null(subdata_df)){
      write.table(subdata_df, file = fileToReport,row.names=FALSE, col.names = FALSE, na = 'NA', sep = ",", append = TRUE)
      data_df <- rbind(data_df, subdata_df)     
    }
  }  
}
cat(sprintf('END OF PROCESSING REPORT FILE\n'))
data_df

# TODO save into reports folder
#fileToReport <- 'C:/Users/jlmartinez/bioreports/reports/disease/disease-test.csv'
##fileToReport <- 'C:/Users/inclusite/bioreports/reports/disease/test.csv'
# http://rprogramming.net/write-csv-in-r/
#cat(sprintf('SAVING REPORT TO: %s \n', fileToReport))
#write.csv(data_df, file = fileToReport,row.names=FALSE, na = '')
