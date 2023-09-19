#!/bin/bash

# Script: vcf_processing.sh
# Description: This script processes a VCF file using various tools.
# Usage: vcf_processing.sh input_vcf output_prefix
#   input_vcf: Path to the input VCF file.
#   output_prefix: Prefix for the output files.

# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_vcf output_prefix"
    echo "Description: This script processes a VCF file using various tools."
    echo "Arguments:"
    echo "  input_vcf:      Path to the input VCF file."
    echo "  output_prefix:  Prefix for the output files."
    exit 1
fi

# Input VCF file and output file prefixes
vcf="$1"
out1="${2}_vcf_data_alter6219287.txt"
out2="${2}_vcf_data_alter6219287.txt.gz"
out3="$2"

# Change the format of the line that is causing issues
cat "$vcf" | sed 's/108,108/108/g;s/172,172/172/' > "$out1"
#out1_copy=`echo copy_ $out1 | sed 's/ //g'`
#cp $out1 $out1_copy

# Set up files: compress and index
bgzip "$out1"
bcftools index "$out2"

# Calculate allele frequency without filtering
vcftools --gzvcf "$out2" --freq2 --out "$out3"

# Calculate site read depth
vcftools --gzvcf "$out2" --site-mean-depth --out "$out3"

# Calculate site quality
vcftools --gzvcf "$out2" --site-quality --out "$out3"

# Calculate the proportion of missing data per site
vcftools --gzvcf "$out2" --missing-site --out "$out3"
