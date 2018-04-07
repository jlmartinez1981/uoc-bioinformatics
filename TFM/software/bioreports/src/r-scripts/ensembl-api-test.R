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
