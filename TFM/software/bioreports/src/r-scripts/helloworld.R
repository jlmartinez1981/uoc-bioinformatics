# Quotes can be suppressed in the output
args = commandArgs(trailingOnly=TRUE)
attach(input[[1]])

print(input, quote = FALSE)