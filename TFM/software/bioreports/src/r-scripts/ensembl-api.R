# http://rest.ensembl.org/
# http://rest.ensembl.org/documentation/info/variation_id
# http://rest.ensembl.org/documentation/info/variation_populations
# http://rest.ensembl.org/documentation/info/ld_id_get

library(httr)
library(jsonlite)
library(xml2)
library(stringr)

population_data_from_snp <- function (rsid, allele1, allele2){
  
  server <- "http://rest.ensembl.org"
  ext <- "/variation/human/##rsid##?pops=1"
  
  # replace rsid
  ext <- str_replace_all(ext, "##rsid##", rsid)
  
  r <- GET(paste(server, ext, sep = ""), content_type("application/json"))
  
  stop_for_status(r)
  
  # use this if you get a simple nested list back, otherwise inspect its structure
  # head(data.frame(t(sapply(content(r),c))))
  
  #head(fromJSON(toJSON(content(r))))
  
  pop_data <- fromJSON(toJSON(content(r)))
  if(typeof(pop_data) == 'list'){
    # select populations from 1000 genomes
    pop_dataframe <- pop_data$populations[which(startsWith(tolower(pop_data$populations$population), "1000genomes")),]
    return(pop_dataframe)
  }
  return(NULL)
}
