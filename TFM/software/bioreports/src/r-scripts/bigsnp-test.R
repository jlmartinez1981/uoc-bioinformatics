#bigsnp test
# https://github.com/privefl/bigsnpr
devtools::install_github("privefl/bigsnpr")

# Get the example bedfile from package bigsnpr
bedfile <- system.file("extdata", "example.bed", package = "bigsnpr")

# Load packages bigsnpr and bigstatsr
library(bigsnpr)

# Read from bed/bim/fam, it will create new files.
# Let's put them in an temporary directory for this demo.
tmpfile <- tempfile()
snp_readBed(bedfile, backingfile = tmpfile)

# Attach the "bigSNP" object in R session
obj.bigSNP <- snp_attach(paste0(tmpfile, ".rds"))
# See how it looks like
str(obj.bigSNP, max.level = 2, strict.width = "cut")

# Get aliases for useful slots
G   <- obj.bigSNP$genotypes
CHR <- obj.bigSNP$map$chromosome
POS <- obj.bigSNP$map$physical.pos
# Check some counts for the 10 first SNPs
big_counts(G, ind.col = 1:10)

############ LD pruning  and clumping #########
set.seed(1)

#test <- snp_attachExtdata()
test_bedfile <- 'C:/Users/jlmartinez/Desktop/plink_win64/23data/kk.bed'
tmpfile <- tempfile()
snp_readBed(test_bedfile, backingfile = tmpfile)
# Attach the "bigSNP" object in R session
test <- snp_attach(paste0(tmpfile, ".rds"))

G <- test$genotypes
n <- nrow(G)
m <- ncol(G)

# pruning / clumping with MAF
ind.keep <- snp_pruning(G, infos.chr = test$map$chromosome, thr.r2 = 0.1)
# keep most of them -> not much LD in this simulated dataset
length(ind.keep) / m
#> [1] 0.9817261

ind.keep2 <- snp_clumping(G, infos.chr = test$map$chromosome, thr.r2 = 0.1)
length(ind.keep2) / m
