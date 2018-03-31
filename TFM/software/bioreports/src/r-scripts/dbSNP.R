#library(biomaRt);
library(reutils);
library(rentrez);

# available databases rentrez
entrez_dbs()
entrez_db_searchable("snp")

#reutils
pmid <- esearch("1:82154", "snp")
pmid

query <- "Chlamydia[mesh] and genome[mesh] and 2013[pdat]"

# Upload the PMIDs for this search to the History server
pmids <- esearch(query, "pubmed", usehistory = TRUE)
pmids
