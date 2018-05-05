#proxysnp

# https://github.com/slowkow/proxysnps
# https://github.com/slowkow/proxysnps/blob/master/vignettes/proxysnps.md
library(proxysnps)

#rs429358 (19:44908684)
#d <- get_proxies(query = "rs429358")

f <- function(input, orig) {
  test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/transformations/LD-proxysnps'
  cat(sprintf('GET PROXIES: %s \n', input[[1]]))
  #d <- get_proxies(query = input[[1]])
  d <- tryCatch({exp=get_proxies(query = input[[1]])}, error=function(i){
    cat(sprintf('ERROR: %s \n', i))
    return(NULL)
  })
  #cat('PRUNNED: ', rsids.ld$V1)
  #cat('CHOSEN: ', d[d$CHOSEN,]$ID)
  if(!is.null(d) && !(d[d$CHOSEN,]$ID[[1]] %in% rsids.ld$V1)){
    d <- d[!d$CHOSEN,]
    aux <- orig[orig$V1 %in% d$ID,]
    #rsids.ld <<-  rbind(rsids.ld, aux)
    write.table(aux, file = test_upload, row.names=FALSE, col.names = TRUE, na = '', sep = ",", append = FALSE)
  }
}

ld_data_from_proxy_snp <- function (rsid = NULL){
  
  kk <- apply(rsid, 1, f, orig = rsid)
  
}