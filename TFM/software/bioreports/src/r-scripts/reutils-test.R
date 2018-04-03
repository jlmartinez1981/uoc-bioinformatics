# https://cran.r-project.org/web/packages/reutils/reutils.pdf
# https://github.com/gschofl/reutils

library(reutils);

#reutils
pmid <- esearch("11:66560624", "snp") # 5 snp results
pmid

#query <- "Chlamydia[mesh] and genome[mesh] and 2013[pdat]"

# Upload the PMIDs for this search to the History server
#pmids <- esearch(query, "pubmed", usehistory = TRUE)
#pmids