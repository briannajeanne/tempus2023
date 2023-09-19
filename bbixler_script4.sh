#!/bin/bash

# Help menu function
show_help() {
    echo "Usage: $0 <input_file> <output_prefix> <path_to_vep_script> <path_to_vep_cache>"
    echo "Arguments:"
    echo "  <input_file>:          Input file for VEP processing"
    echo "  <output_prefix>:      Prefix for output files"
    echo "  <path_to_vep_script>: Path to the VEP script"
    echo "  <path_to_vep_cache>:  Path to the VEP cache directory"
    echo
    echo "Options:"
    echo "  -h, --help:           Show this help message and exit"
    exit 1
}

# Check if the help flag is provided
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

# Check for the required number of arguments
if [ $# -ne 4 ]; then
    echo "Error: Incorrect number of arguments."
    show_help
fi

# Assign the remaining arguments
input="$1"
output_prefix="$2"
path_vep_script="$3"
path_vep_cache="$4"

# Rest of your script
output1=$(echo "${output_prefix}_vep.txt" | sed 's/ //g')
output2=$(echo "${output_prefix}.join" | sed 's/ //g')

"$path_vep_script" --cache "$path_vep_cache" -i "$input" -o "$output1" --variant_class

cat $output1 | grep -v "#" | sed 's/;/\t/g' | awk '{print $1"\t"$2"\t"$7"\t"$NF}' | \
    sed 's/VARIANT_CLASS=//g' | sort -k 2,2b --stable > "$output2"
