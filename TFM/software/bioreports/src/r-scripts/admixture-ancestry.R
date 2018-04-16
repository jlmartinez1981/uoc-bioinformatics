# radmixture ancestry analysis
# radixture test
library(radmixture)

# calculate individual ancestry
ancestry_from_snp_file <- function (path_to_file){
  # path_to_file = 'C:/Users/jlmartinez/Desktop/7210.23andme.5592.txt';
  genotype <- read.table(file = path_to_file)
  
  load(paste(getwd(), '/ancestry-reference-data/globe13.alleles.RData', sep = ""))
  load(paste(getwd(), '/ancestry-reference-data/globe13.13.F.RData', sep = ""))
  
  # Use K13
  res <- tfrdpub(genotype, 13, globe13.alleles, globe13.13.F)
  
  # Use K13
  ances <- fFixQN(res$g, res$q, res$f, tol = 1e-4, method = "BR", pubdata = "K13")
  
  ances$q
  return(ances$q)
}
