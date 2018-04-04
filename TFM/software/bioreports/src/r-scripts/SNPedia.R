#snpedia test
source("https://bioconductor.org/biocLite.R")
biocLite("SNPediaR")

#https://www.snpedia.com/index.php/Help_(population_diversity)
library (SNPediaR)
pg <- getPages (titles = "Rs429358")
pg

test_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/test-upload2.txt'
write.table(pg, file = test_upload, sep = "\t",
            row.names = TRUE, col.names = NA)

#https://cran.r-project.org/web/packages/WikipediR/WikipediR.pdf
library(WikipediR)

#categories_in_page(language = NULL, project = NULL, domain = NULL, pages,
#                   properties = c("sortkey", "timestamp", "hidden"), limit = 50,
#                   show_hidden = FALSE, clean_response = FALSE, ...)


extractSnpTags (pg$Rs429358)
extractGenotypeTags(pg$Rs429358)
extractTags(pg$Rs429358, tags = c('Assembly','population diversity', 'Gene'))

findPMID <- function (x) {
  x <- unlist (strsplit (x, split = "\n"))
  #x <- grep ("\\{.*population diversity *\\}", x, value = TRUE)
  x <- grep ("population diversity\\.\\}", x, value = TRUE)
  x
}
  
getPages (titles = c ("Rs429358"),
            wikiParseFunction = findPMID)
