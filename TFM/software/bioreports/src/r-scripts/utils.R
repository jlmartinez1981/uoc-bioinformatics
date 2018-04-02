library(stringr)

extractChrPos <- function(x) {
  
  paste(str_replace_all(x[2], "^\\s+|\\s+$", ""),
        str_replace_all(x[3], "^\\s+|\\s+$", ""), sep=":")
}

extractRsId <- function(x) {
  str_replace_all(x[1], "^\\s+|\\s+$", "")
}
