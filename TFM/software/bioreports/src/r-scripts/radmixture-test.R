# radixture test
library(radmixture)

path_to_file = 'C:/Users/jlmartinez/Desktop/7210.23andme.5592.txt';
genotype <- read.table(file = path_to_file)

#download reference files
#download.file(url = 'https://github.com/wegene-llc/radmixture/raw/master/data/globe4.alleles.RData', destfile = 'C:/Users/jlmartinez/Desktop/reference-data/globe4.alleles.RData')
#download.file(url = 'https://github.com/wegene-llc/radmixture/raw/master/data/globe4.4.F.RData', destfile = 'C:/Users/jlmartinez/Desktop/reference-data/globe4.4.F.RData')

load('C:/Users/jlmartinez/Desktop/reference-data/globe4.alleles.RData')
load('C:/Users/jlmartinez/Desktop/reference-data/globe4.4.F.RData')

load('C:/Users/jlmartinez/Desktop/reference-data/globe13.alleles.RData')
load('C:/Users/jlmartinez/Desktop/reference-data/globe13.13.F.RData')

# Use K4
res <- tfrdpub(genotype, 4, globe4.alleles, globe4.4.F)
# Use K13
res <- tfrdpub(genotype, 13, globe13.alleles, globe13.13.F)

# Use K4
ances <- fFixQN(res$g, res$q, res$f, tol = 1e-4, method = "BR", pubdata = "K4")
# Use K13
ances <- fFixQN(res$g, res$q, res$f, tol = 1e-4, method = "BR", pubdata = "K13")

ances$q

#par("mar")
#ORIGINAL VALUES [1] 5.1 4.1 4.1 2.1
#par(mar=c(1,1,1,1))

#plot(ances$q)
#boxplot(ances$q)
#pie(ances$q)
