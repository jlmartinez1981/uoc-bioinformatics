#SNPRelates test
workingDirectory = 'C:/Users/jlmartinez/Desktop/UOC-Bioinformatics/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
#workingDirectory = 'C:/Users/inclusite/Documents/uoc-bioinformatics/TFM/software/bioreports/src/r-scripts';
setwd(workingDirectory);

#clean variables
rm(list = ls())

#source("http://bioconductor.org/biocLite.R")
#biocLite("gdsfmt")
#biocLite("SNPRelate")

library("SNPRelate")
snpgdsSummary(snpgdsExampleFileName())
(genofile <- snpgdsOpen(snpgdsExampleFileName()))

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/20180416200548-disease-7210.23andme.5592-no-mt.csv'
rawData <- read.csv(file=test_upload, header=FALSE, sep=" ", stringsAsFactors = FALSE)

plink_output <- 'C:/Users/jlmartinez/bioreports/upload_processed/transformations/20180416200548-disease-7210.23andme.5592-no-mt'
#plink --23file test.txt --snps-only no-DI --make-bed --out bed_file
plink_command <- paste("plink --23file", test_upload, "--snps-only no-DI --make-bed --out", plink_output)
system(command = plink_command)

#bed.fn <- "C:/Users/jlmartinez/Desktop/plink_win64/23data/plink_genome.bed"
#fam.fn <- "C:/Users/jlmartinez/Desktop/plink_win64/23data/plink_genome.fam"
#bim.fn <- "C:/Users/jlmartinez/Desktop/plink_win64/23data/plink_genome.bim"

bed.fn <- "C:/Users/jlmartinez/bioreports/upload_processed/transformations/20180416200548-disease-7210.23andme.5592-no-mt.bed"
fam.fn <- "C:/Users/jlmartinez/bioreports/upload_processed/transformations/20180416200548-disease-7210.23andme.5592-no-mt.fam"
bim.fn <- "C:/Users/jlmartinez/bioreports/upload_processed/transformations/20180416200548-disease-7210.23andme.5592-no-mt.bim"

# Convert
#snpgdsBED2GDS(bed.fn, fam.fn, bim.fn, "C:/Users/jlmartinez/Desktop/test.gds")
snpgdsBED2GDS(bed.fn, fam.fn, bim.fn, "C:/Users/jlmartinez/bioreports/upload_processed/transformations/20180416200548-disease-7210.23andme.5592-no-mt.gds")
# Summary
#snpgdsSummary("C:/Users/jlmartinez/Desktop/test.gds")

#genofile <- snpgdsOpen("C:/Users/jlmartinez/Desktop/test.gds")
genofile <- snpgdsOpen("C:/Users/jlmartinez/bioreports/upload_processed/transformations/20180416200548-disease-7210.23andme.5592-no-mt.gds")

# read data from all snps
rsids.all <- read.gdsn(index.gdsn(genofile, "snp.rs.id"))
#snpids.all <- read.gdsn(index.gdsn(genofile, "snp.id"))

# Try different LD thresholds for sensitivity analysis
snpset <- snpgdsLDpruning(genofile, ld.threshold=0.2)

# close gds file
snpgdsClose(genofile)

# Get all selected snp id
snpset.id <- unlist(snpset, use.names = FALSE)

rsids.pruned <- c()
for(i in snpset.id){
  rsids.pruned <- c(rsids.pruned, rsids.all[i])
}

filtered_ld_snps <- rawData[rawData$V1 %in% rsids.pruned,]

filter1 <- subset(rawData, !(rsids %in% rawData$V1))

