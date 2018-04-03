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

extractSnpTags (pg$Rs429358)
extractGenotypeTags(pg$Rs429358)
extractTags(pg$Rs429358, tags = c('population diversity', 'Gene'))
