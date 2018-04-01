library(stringr)

extractChrPos <- function(x) {
  
  paste(str_replace_all(x[2], "^\\s+|\\s+$", ""),
        str_replace_all(x[3], "^\\s+|\\s+$", ""), sep=":")
}

extractRsId <- function(x) {
  str_replace_all(x[1], "^\\s+|\\s+$", "")
}

extractSNPData <- function(x, params) {
  snp_id <- x["snp_id"]
  clinical_sig <- x["clinical_significance"]
  # get it from clinvar gene_sort field
  #genes <- x["genes"]
  chr_pos <- x["chrpos"]
  allele_origin <- x["allele_origin"]
  paste(snp_id, clinical_sig, chr_pos, allele_origin, sep = '#')
}

extractGeneNames <- function(x) {
  geneName <- x[1]["name"]
  return (geneName)
} 

# apply(d, 1, f, params = 'outputfile')