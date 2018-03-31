library(stringr)
attach(input[[1]])

con <- file(scriptArgs[[2]], open = 'r')
while(TRUE) {
    line <- readLines(con, n = 1)
    if(length(line) == 0) break
    else if(!startsWith(line, "#")){
        line <- str_replace_all(line, "[:blank:]+", " ")
        #remove starting or ending spaces if exists
        #line <- str_replace(line, "[:blank:]+$", "")
        line <- str_replace_all(line, "^\\s+|\\s+$", "")
        write(line, file = scriptArgs[[1]], append = TRUE)
    } 
}
