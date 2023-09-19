#!/bin/bash

# Help menu function
show_help() {
    echo "Usage: $0 [options] <input_file> <output_prefix> <path_to_vep_script> <path_to_vep_cache> [path_to_scripts]"
    echo "Options:"
    echo "  -h, --help             Show this help message and exit"
    exit 1
}

# Default values
path_to_scripts="./"

# Parse command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help)
            show_help
            ;;
        *)
            break
            ;;
    esac
done

# Check for the required number of arguments
if [ $# -lt 4 ]; then
    echo "Error: Incorrect number of arguments."
    show_help
fi

# Assign the first four arguments
input_file="$1"
output_prefix="$2"
path_vep_script="$3"
path_vep_cache="$4"

# Check if the fifth argument (path_to_scripts) is provided
if [ $# -eq 5 ]; then
    path_to_scripts="$5"
fi

# Ensure the path_to_scripts variable has a trailing "/"
if [ "${path_to_scripts: -1}" != "/" ]; then
    path_to_scripts="${path_to_scripts}/"
fi

# Ass0ign the arguments to input_file
#input_file="$1"
#output_prefix="$2"
#path_vep_script="$3"
#path_vep_cache="$4"
#path_to_scripts="$5"


prefix1="step1"
prefix2="step2"
prefix3="step3"
prefix4="step4"

vcfalter=`echo $prefix2 _vcf_data_alter6219287.txt | sed 's/ //g'`
vcfaltergz=`echo $vcfalter .gz | sed 's/ //'`
s3_input=`echo $prefix2 .frq | sed 's/ //'`
s1=`echo $path_to_scripts bbixler_script1.py | sed 's/ //'`
s2=`echo $path_to_scripts bbixler_script2.sh | sed 's/ //'`
s3=`echo $path_to_scripts bbixler_script3.r | sed 's/ //'`
s4=`echo $path_to_scripts bbixler_script4.sh | sed 's/ //'`
s5=`echo $path_to_scripts bbixler_script5.sh | sed 's/ //'`

output=`echo bbixler_ $output_prefix _final.tab | sed 's/ //g'`

echo "$s1 $input_file $prefix1" > runner.log
$s1 $input_file $prefix1

echo "$s2 $input_file $prefix2" >> runner.log
$s2 $input_file $prefix2

echo "$s3 $s3_input $prefix3" >> runner.log
$s3 $s3_input $prefix3

echo "$s4 $vcfaltergz $prefix4 $path_vep_script $path_vep_cache" >> runner.log
$s4 $vcfaltergz $prefix4 $path_vep_script $path_vep_cache

echo "$s5 $prefix1 $prefix3 $output" >> runner.log
$s5 $prefix1 $prefix3 $output

echo "done running"


