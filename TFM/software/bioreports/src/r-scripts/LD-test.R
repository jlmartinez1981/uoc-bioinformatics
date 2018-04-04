#LD test
source("https://bioconductor.org/biocLite.R")
biocLite("myvariant")

# https://cran.r-project.org/web/packages/genetics/genetics.pdf

# https://github.com/slowkow/proxysnps
# https://github.com/slowkow/proxysnps/blob/master/vignettes/proxysnps.md
library(proxysnps)

#rs429358 (19:44908684)
d <- get_proxies(query = "rs42")
plot(d$POS, d$R.squared, main="rs42", xlab="Position", ylab=bquote("R"^2))

d <- get_proxies(chrom = "19", pos = 44908684)
head(d)

#genetics
library(genetics)
g1 <- genotype(c('T/A',NA,'T/T',NA,'T/A', NA,'T/T','T/A','T/T','T/T','T/A','A/A','T/T','T/A','T/A','T/T',NA,'T/A','T/A',NA))
g2 <- genotype(c('C/A','C/A','C/C','C/A','C/C','C/A','C/A','C/A','C/A','C/C','C/A','A/A','C/A','A/A','C/A','C/C','C/A','C/A','C/A','A/A'))
LD(g1,g2)
