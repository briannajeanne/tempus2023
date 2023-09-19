#!/bin/bash

# Script: process_data.sh
# Description: This script processes input files and creates an output file.
# Usage: ./process_data.sh <prefix1> <prefix3> <output>
#   <prefix1>: Prefix for the first input file (e.g., input1)
#   <prefix3>: Prefix for the third input file (e.g., input3)
#   <output>:  Output file name (e.g., output.tab)
#
# Example:
#   ./process_data.sh input1_prefix input3_prefix output_file
#
# Options:
#   None
#
# Note: Make sure the required input files exist before running the script.
# Dependencies: None

# Check if the required number of arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <prefix1> <prefix3> <output>"
    exit 1
fi

# Assign input variables
prefix1="$1"
prefix3="$2"
output="$3"

input1=`echo $prefix1 .tab | sed 's/ //g'`
input3=`echo $prefix3 _maf.tab | sed 's/ //g'`


cat $input1 | grep -v "#" | awk '{print $1"_"$2"_"$4"/"$5"\t"$1":"$2"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10}' |\
 sort -k 2,2b --stable > step1.join

#join step 1 and step 4
join -j 2 step1.join step4.join > tmp1

#create maf join file
cat $input3 | grep -v "maf" | awk '{print $1":"$2"\t"$1":"$2"\t"$3"\t"$4"\t"$5"\t"$6}' |\
sort -k 1,1b --stable > step3.join

#join step 1, step 3, and step 4 for completed table, reorgranize for readability 
join -j 1 tmp1 step3.join | awk '{print $2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$9"\t"$10"\t"$15"\t"$7}' > tmp2

#add standard header for ease pf downstream
echo "#chr_start_mutation Q1 Q2 Q3A Q3B Q4A Q4B Q5 Q6" | sed 's/ /\t/g' > header.tab
cat header.tab tmp2 > $output

#rm tmp1 tmp2
