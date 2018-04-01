#library(biomaRt);
#library(reutils);
library(rentrez);
# https://cran.r-project.org/web/packages/rentrez/vignettes/rentrez_tutorial.html
# https://www.ncbi.nlm.nih.gov
source("utils.R")
# available databases rentrez
entrez_dbs()
# db links to snp db
linkedDBs <- entrez_db_links(db = "snp")
# summary
entrez_db_summary("snp")
# searchable fields
entrez_db_searchable("snp")

# chr:position example 1:82154 (2 items), 19:44908684 (pathogenic)
# rsId example rs4477212 (2 itmes, same as above), rs429358 (pathogenic)
# search_string <- sprintf('%s[CHR] AND %s[CPOS] AND HUMAN[ORGN]', 1, 82154) 
search_string <- sprintf('%s[CHR] AND %s[CPOS] AND HUMAN[ORGN]', 19, 44908684) 

rs_id <- 'rs429358'
search_term <- rs_id;
snp_search <- entrez_search(db="snp",
                            term=search_term,
                            retmax=20)
snp_search
snp_search$ids

search_term <- search_string;
snp_search <- entrez_search(db="snp",
                            term=search_term,
                            retmax=20)
snp_search
snp_search$ids

# get the links
#all_the_links <- entrez_link(dbfrom='snp', id=snp_search$ids, db='all')
#all_the_links$links

# all_the_links$links$snp_clinvar

# fetch only clinvar
clinvar_links <- entrez_link(dbfrom='snp', id=snp_search$ids, db='clinvar')
clinvar_links$links$snp_clinvar

# stopifnot(!(is.null(clinvar_links$links$snp_clinvar)))
if(is.null(clinvar_links$links$snp_clinvar)){
  sprintf('NO CLINVAR LINKS for: %s', rs_id)
}

#rs429358
snp_summary <- entrez_summary(db='snp',id = snp_search$ids)
df <- data.frame(matrix(unlist(snp_summary), nrow=length(snp_summary), byrow=T),stringsAsFactors=FALSE)
# column names (2,4,9,10,37)
snp_df <- df[,c(2,4,9,10,37)]
snp_colnames <- c("snp_id","allele_origin", "clinical_significance", "gene_name", "chrpos")
colnames(snp_df) <- snp_colnames
#remove duplicated rows https://stats.stackexchange.com/questions/6759/removing-duplicated-rows-data-frame-in-r
snp_df <- snp_df[!duplicated(snp_df),]

# TODO extract snp report data
#snp_data <-  lapply(snp_summary, extractSNPData, params = 'outputfile');
# convert to data frame
#df <- data.frame(matrix(unlist(snp_data), nrow=length(snp_data), byrow=T),stringsAsFactors=FALSE)

#if id = null, error, Error: Must specify either (not both) 'id' or 'web_history' arguments
clinvar_summary <- entrez_summary(db='clinvar',id = clinvar_links$links$snp_clinvar)
#entrez_fetch(db='snp',id = snp_search$ids[3], rettype = 'xml')

# 441269
omim_links <- entrez_link(dbfrom = 'clinvar', id=clinvar_summary[[1]]$uid, db='omim')
omim_summary <- entrez_summary(db='omim',id = omim_links$links$clinvar_omim)
#omim_summary

#reutils
#pmid <- esearch("1:82154", "snp")
#pmid

#query <- "Chlamydia[mesh] and genome[mesh] and 2013[pdat]"

# Upload the PMIDs for this search to the History server
#pmids <- esearch(query, "pubmed", usehistory = TRUE)
#pmids
