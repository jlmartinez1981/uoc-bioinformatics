# http://rest.ensembl.org/
# http://rest.ensembl.org/documentation/info/variation_id
# http://rest.ensembl.org/documentation/info/variation_populations
# http://rest.ensembl.org/documentation/info/ld_id_get

library(httr)
library(jsonlite)
library(xml2)

server <- "http://rest.ensembl.org"
ext <- "/variation/human/rs56116432?pops=1"

r <- GET(paste(server, ext, sep = ""), content_type("application/json"))

stop_for_status(r)

# use this if you get a simple nested list back, otherwise inspect its structure
# head(data.frame(t(sapply(content(r),c))))
head(fromJSON(toJSON(content(r))))

pop_data <- fromJSON(toJSON(content(r)))
if(typeof(pop_data) == 'list'){
  # select populations from 1000 genomes
  pop_dataframe <- pop_data$populations[which(startsWith(tolower(pop_data$populations$population), "1000genomes")),]
  # a <- pop_dataframe[which((pop_dataframe$allele == 'C')) ,c(2,3,4)]
  # a[which(grepl("phase_3",a$population)),]
}
