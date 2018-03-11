# Modify this depending on the computer
workingDirectory = 'C:/Users/jmartiez/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#library(biomaRt);
library(reutils);
library(rentrez);

# available databases rentrez
entrez_dbs()
entrez_db_searchable("snp")

#reutils
pmid <- esearch("asthma", "snp")
pmid
