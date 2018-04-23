#snprelates LD

library("SNPRelate")

ld_data_from_snp <- function (orig_file = NULL, transform_dir = NULL, transform_file = NULL){
  
  basename("C:/some_dir/a.ext")
  # [1] "a.ext"
  dirname("C:/some_dir/a.ext")
  # [1] "C:/some_dir"
  
  orig_file <- 'C:/Users/jlmartinez/bioreports/upload_processed/20180416200548-disease-7210.23andme.5592-no-mt.csv'
  transform_dir <- 'C:/Users/jlmartinez/bioreports/upload_processed/transformations/'
  transform_file <- paste(transform_dir, '20180416200548-disease-7210.23andme.5592', sep = '')
  
  #plink --23file test.txt --snps-only no-DI --make-bed --out bed_file
  plink_command <- paste("plink --23file", orig_file, "--snps-only no-DI --make-bed --out", transform_file)
  system(command = plink_command)
  
  bed.fn <- paste(transform_dir, '/', transform_file, ".bed", sep = '')
  fam.fn <- paste(transform_dir, '/', transform_file, ".fam", sep = '')
  bim.fn <- paste(transform_dir, '/', transform_file, ".bim", sep = '')
  
  gds_file <- paste(transform_dir, transform_file, ".gds", sep = '')
  # Convert
  snpgdsBED2GDS(bed.fn, fam.fn, bim.fn, gds_file)
  # Summary
  # snpgdsSummary("C:/Users/jlmartinez/Desktop/test.gds")
  
  genofile <- snpgdsOpen(gds_file)
  # Try different LD thresholds for sensitivity analysis
  snpset <- snpgdsLDpruning(genofile, ld.threshold=0.2)
  
  # Get all selected snp id
  snpset.id <- unlist(snpset)
  
  return(snpset.id)
}