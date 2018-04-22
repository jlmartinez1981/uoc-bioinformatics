#SNPRelates test
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
#workingDirectory = 'C:/Users/inclusite/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())

source("http://bioconductor.org/biocLite.R")
biocLite("gdsfmt")
biocLite("SNPRelate")

library("SNPRelate")
snpgdsSummary(snpgdsExampleFileName())
(genofile <- snpgdsOpen(snpgdsExampleFileName()))

bed.fn <- "C:/Users/jlmartinez/Desktop/plink_win64/23data/plink_genome.bed"
fam.fn <- "C:/Users/jlmartinez/Desktop/plink_win64/23data/plink_genome.fam"
bim.fn <- "C:/Users/jlmartinez/Desktop/plink_win64/23data/plink_genome.bim"

# Convert
snpgdsBED2GDS(bed.fn, fam.fn, bim.fn, "C:/Users/jlmartinez/Desktop/test.gds")
# Summary
snpgdsSummary("C:/Users/jlmartinez/Desktop/test.gds")

# Try different LD thresholds for sensitivity analysis
snpset <- snpgdsLDpruning(genofile, ld.threshold=0.2)

genofile2 <- snpgdsOpen("C:/Users/jlmartinez/Desktop/test.gds")
# Try different LD thresholds for sensitivity analysis
snpset2 <- snpgdsLDpruning(genofile2, ld.threshold=0.2)

# Get all selected snp id
snpset2.id <- unlist(snpset2)
