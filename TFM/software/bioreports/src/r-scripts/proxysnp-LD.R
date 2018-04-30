#proxysnp

# https://github.com/slowkow/proxysnps
# https://github.com/slowkow/proxysnps/blob/master/vignettes/proxysnps.md
library(proxysnps)

#rs429358 (19:44908684)
d <- get_proxies(query = "rs429358")

ld_data_from_proxy_snp <- function (rsid = NULL){
  ld_proxies <- get_proxies(query = "rs429358")
  return(ld_proxies)
  
}