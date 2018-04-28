#snprelates LD
# https://bioconductor.org/packages/release/bioc/vignettes/SNPRelate/inst/doc/SNPRelateTutorial.html#ld-based-snp-pruning
# http://corearray.sourceforge.net/tutorials/SNPRelate/#overview
# https://bioconductor.org/packages/3.7/bioc/manuals/SNPRelate/man/SNPRelate.pdf
# https://github.com/zhengxwen/SNPRelate/blob/master/R/Conversion.R
# https://github.com/zhengxwen/SNPRelate/wiki/Preparing-Data


library("SNPRelate")

ld_data_from_snp <- function (orig_file = NULL, transform_file_name = NULL, ld_treshold = 0.2){
  
  #orig_file <- 'C:/Users/jlmartinez/bioreports/upload_processed/20180416200548-disease-7210.23andme.5592-no-mt.csv'
  transform_dir <- 'C:/Users/jlmartinez/bioreports/upload_processed/transformations/'
  transform_file <- paste(transform_dir, transform_file_name, sep = '')
  
  #plink --23file test.txt --snps-only no-DI --make-bed --out bed_file
  plink_command <- paste("plink --23file", orig_file, "--snps-only no-DI --make-bed --out", transform_file)
  plink_command
  system(command = plink_command)
  
  bed.fn <- paste(transform_dir, transform_file_name, ".bed", sep = '')
  fam.fn <- paste(transform_dir, transform_file_name, ".fam", sep = '')
  bim.fn <- paste(transform_dir, transform_file_name, ".bim", sep = '')
  
  gds_file <- paste(transform_dir, transform_file_name, ".gds", sep = '')
  # Convert
  snpgdsBED2GDS(bed.fn, fam.fn, bim.fn, gds_file)
  # Summary
  # snpgdsSummary("C:/Users/jlmartinez/Desktop/test.gds")
  
  # open file
  genofile <- snpgdsOpen(gds_file)
  
  # read data from all snps
  rsids.all <- read.gdsn(index.gdsn(genofile, "snp.rs.id"))
  
  # Try different LD thresholds for sensitivity analysis
  snpset <- snpgdsLDpruning(genofile, ld.threshold= ld_treshold)
  
  # close gds file
  snpgdsClose(genofile)
  
  # Get all selected snp id
  #snpset.id <- unlist(snpset)
  snpset.id <- unlist(snpset, use.names = FALSE)
  
  rsids.pruned <- c()
  for(i in snpset.id){
    rsids.pruned <- c(rsids.pruned, rsids.all[i])
  }
  
  #return(snpset.id)
  return(rsids.pruned)
  
}