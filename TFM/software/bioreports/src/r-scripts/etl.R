library(stringr)

etl <- function (fileToRead, fileToWrite){
    con <- file(fileToRead, open = 'r')
    while(TRUE) {
        line <- readLines(con, n = 1)
        if(length(line) == 0) break
        # remove comments and headers
        else if(!startsWith(line, "#") && !(grepl("rsid", tolower(line)))){
            line <- str_replace_all(line, "[:blank:]|,+", " ")
            #remove starting or ending spaces if exists
            line <- str_replace_all(line, "^\\s+|\\s+$", "")
            # remove quotes
            line <- str_replace_all(line, "\"", "")
            fields <- strsplit(line, " ")[[1]]
            rsid_field <- fields [1]
            chr_field <- fields[2]
            pos_field <- fields[3]
            allele1_field <- fields[4]
            allele2_field <- fields[5]
            genotype_field <- paste(allele1_field, allele2_field, sep = "")
            if(nchar(allele1_field) > 1){
              allele1_field <- substr(fields[4],1,1)
              allele2_field <- substr(fields[4],2,2)
              genotype_field <- paste(allele1_field, allele2_field, sep = "")
            }
            etl_line <- paste(rsid_field, chr_field, pos_field, genotype_field, sep = " ")
            write(etl_line, file = fileToWrite, append = TRUE)
        } 
    }
    close(con)
    return(TRUE);
}
