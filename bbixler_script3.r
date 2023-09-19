#!/usr/bin/env Rscript

# Check if command-line arguments are provided
if (length(commandArgs(trailingOnly = TRUE)) != 2) {
  cat("Usage: Rscript script.R input_file output_prefix\n")
  quit(status = 1)
}

# Get input and output file paths from the command line
input_file <- commandArgs(trailingOnly = TRUE)[1]
output_file <- commandArgs(trailingOnly = TRUE)[2]

# Check if the input file exists
if (!file.exists(input_file)) {
  cat("Input file does not exist.\n")
  quit(status = 1)
}

# Perform some operation using the input file
library(dplyr)

#input="vcftools_out.frq"
#output="/home/tera2/Labwork/tempus_coding/maf.tab"

column_names <- c("chr", "pos", "nalleles", "nchr", "a1", "a2")

#dif number of column names need to figure out
#var_freq = read.delim(input_file, header = TRUE, sep = "\t", col.names = column_names)
var_freq = read.delim(input_file, header = FALSE, sep = "\t", skip=1)
colnames(var_freq)=column_names
#calc maf 
var_freq$maf <- var_freq %>% select(a1, a2) %>% apply(1, function(z) min(z))

#write out 
#write.table(var_freq, file = output_file , sep = "\t", quote= FALSE, row.names = FALSE)
output_end = paste0(output_file,"_maf.tab")
write.table(var_freq, file = output_end, sep = "\t", quote= FALSE, row.names = FALSE)
