#ensembl db
# http://www.ensembl.info/2015/06/01/biomart-or-how-to-access-the-ensembl-data-from-r/
# https://bioconductor.org/packages/release/bioc/html/biomaRt.html
source("http://bioconductor.org/biocLite.R")
biocLite("biomaRt")

library(biomaRt)

listMarts()
listEnsembl()

variation = useEnsembl(biomart="snp")

listDatasets(variation)
head(listDatasets(variation))

variation = useEnsembl(biomart="snp", dataset="hsapiens_snp")

listFilters(variation)
atts <- listAttributes(variation)
atts 
rsId <- 'rs429358'
rsData <- getBM(attributes=c('clinical_significance','refsnp_id',
                                'refsnp_source','chr_name','chrom_start',
                                'chrom_end','minor_allele','minor_allele_freq',
                                'minor_allele_count','consequence_allele_string',
                                'ensembl_gene_stable_id','ensembl_transcript_stable_id'),
                   filters = 'snp_filter', values = rsId, mart = variation)
rsData

