library(stringr)

etl <- function (fileToRead, fileToWrite){
    con <- file(fileToRead, open = 'r')
    while(TRUE) {
        line <- readLines(con, n = 1)
        if(length(line) == 0) break
        else if(!startsWith(line, "#")){
            line <- str_replace_all(line, "[:blank:]+", " ")
            #remove starting or ending spaces if exists
            #line <- str_replace(line, "[:blank:]+$", "")
            line <- str_replace_all(line, "^\\s+|\\s+$", "")
            write(line, file = fileToWrite, append = TRUE)
        } 
    }
    return(1);
}
