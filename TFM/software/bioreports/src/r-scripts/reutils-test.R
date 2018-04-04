# https://cran.r-project.org/web/packages/reutils/reutils.pdf
# https://github.com/gschofl/reutils

library(reutils);
library(XML)

#reutils
pmid <- esearch("11:66560624", "snp") # 5 snp results
pmid

xml_upload <- 'C:/Users/jlmartinez/bioreports/upload_processed/kk.xml'
xmlFile <- efetch(pmid, db = "snp", rettype = NULL, retmode = NULL, outfile = NULL,
       retstart = NULL, retmax = NULL, querykey = NULL, webenv = NULL,
       strand = NULL, seqstart = NULL, seqstop = NULL, complexity = 0)

saveXML(content(xmlFile), xml_upload)