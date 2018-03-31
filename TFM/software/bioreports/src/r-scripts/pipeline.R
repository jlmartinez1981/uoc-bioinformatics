# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
remove(etl)
# Quotes can be suppressed in the output
if(!exists("etl", mode="function")){
  source("etl.R")
} 

args = commandArgs(trailingOnly=TRUE)

print(args, quote = FALSE)
print(args[1], quote = FALSE)
print(args[2], quote = FALSE)

etlRes <- etl()
etlRes

#for (i in 0:100){
#  print(paste("The year is", i))
#}