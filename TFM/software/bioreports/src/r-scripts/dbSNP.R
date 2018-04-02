#library(reutils);
library(rentrez);
# https://cran.r-project.org/web/packages/rentrez/vignettes/rentrez_tutorial.html
# https://www.ncbi.nlm.nih.gov

disease_data_from_snp <- function (chr, pos){
  search_string <- sprintf('%s[CHR] AND %s[CPOS] AND HUMAN[ORGN]', chr, pos) 
  
  search_term <- search_string;
  snp_search <- entrez_search(db="snp",
                              term=search_term,
                              retmax=20)
  
  # fetch only clinvar
  clinvar_links <- entrez_link(dbfrom='snp', id=snp_search$ids, db='clinvar')
  clinvar_links$links$snp_clinvar
  
  if(is.null(clinvar_links$links$snp_clinvar)){
    sprintf('NO CLINVAR LINKS for: %s:%s', chr, pos)
    return(NULL)
  }
  
  snp_summary <- entrez_summary(db='snp',id = snp_search$ids)
  snp_info <- unlist(extract_from_esummary(snp_summary, c("snp_id","allele_origin", "clinical_significance", "genes", "chrpos")))
  df <- data.frame(matrix(unlist(snp_summary), nrow=length(snp_summary), byrow=T),stringsAsFactors=FALSE)
  # column names (2,4,9,10,37)
  snp_df <- df[,c(2,4,9,10,37)]
  snp_colnames <- c("snp_id","allele_origin", "clinical_significance", "gene_name", "chrpos")
  colnames(snp_df) <- snp_colnames
  #remove duplicated rows https://stats.stackexchange.com/questions/6759/removing-duplicated-rows-data-frame-in-r
  snp_df <- snp_df[!duplicated(snp_df),]
  
  #if id = null, error, Error: Must specify either (not both) 'id' or 'web_history' arguments
  clinvar_summary <- entrez_summary(db='clinvar',id = clinvar_links$links$snp_clinvar)
  
  #get uids for querying OMIM
  clinvar_uids <- extract_from_esummary(clinvar_summary, c("uid"))
  clinvar_uids <- unname(clinvar_uids)
  
  # 441269
  #omim_links <- entrez_link(dbfrom = 'clinvar', id=clinvar_summary[[3]]$uid, db='omim')
  omim_links <- entrez_link(dbfrom = 'clinvar', id=clinvar_uids, db='omim')
  if(is.null(omim_links$links$clinvar_omim)){
    sprintf('NO OMIM LINKS for: %s:%s', chr, pos)
    return(NULL)
  }
  omim_summary <- entrez_summary(db='omim',id = omim_links$links$clinvar_omim)
  #omim_summary
  
  diseases <- extract_from_esummary(omim_summary, c("title"))
  diseases <- unname(diseases)
  diseases <- paste(diseases, collapse = '#')
  
  snp_df$diseases <- diseases
  return(snp_df)
}
