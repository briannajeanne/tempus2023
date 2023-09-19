#!/usr/bin/env python3

import argparse
import pandas as pd
import numpy as np
import warnings

warnings.filterwarnings("ignore")

###---------------------------------------------------- foundational things ----------------###
def main():
    parser = argparse.ArgumentParser(description='Process VCF data and answer questions 1, 2, 3, and 6.')
    parser.add_argument('input_file', help='Input VCF data file path')
    parser.add_argument('output_prefix', help='Output file prefix')

    args = parser.parse_args()

    input_file = args.input_file
    output_file = f"{args.output_prefix}_vcf-allfields_reformat.tab"
    output_file1 = f"{args.output_prefix}.tab"

###------------------------------------------------------- Block 1: Reformat file -------###
#read the input file into pandas DataFrame
    df = pd.read_csv(input_file, sep='\t', comment='#', header=None)
#select and rename columns
    df = df[[0, 1, 2, 3, 4, 7, 9]]
    df.columns = ['col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7']
#split original column by ';' or ":" and expand into new columsn
    df[[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]] = df['col6'].str.split(";",expand=True)
    df[[21,22,23,24,25,26]] = df['col7'].str.split(":",expand=True)
#select columns of interest
    dfsub=df.iloc[:,np.r_[0:5,7:33]]

#remove the variable names in the names so nothing is a mix of numeric/string
    for x in range(5,25):
        if x < len(dfsub.columns):
            dfsub.iloc[:, x] = dfsub.iloc[:, x].str.split('=').str[1]
#save progress into a useful intermediate file
    dfsub.to_csv(output_file, sep='\t', index=False, header=False)

###-------------------------------------------- Block 2: Create tab file for answers 1, 2, 3, 6 --------###
#read the reformatted file into pandas DataFrame. this also fixes the inconsistent column names above 
    df = pd.read_csv(output_file, sep='\t', header=None)
#select columns of interest
    dfsub=df.iloc[:,np.r_[0:5,19,22,29,30]]
    dfsub.columns = ['col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7', 'col8','col9']

#it seems TR is misformatted by repeating the same number twice separated by comma
#### XXX flag this as a question XXX
#ValueError: Unable to parse string "108,108" at position 39
# *** write an awk script to handle this downstream
    dfsub['col7'] = dfsub['col7'].str.split(',').str[0]
    dfsub['col8'] = dfsub['col8'].str.split(',').str[0]
    dfsub['col9'] = dfsub['col9'].str.split(',').str[0]
#loop through and make things numeric
    for x in range(6, 10):
        col_name = f'col{x}'
        if col_name in dfsub.columns:
            dfsub[col_name] = pd.to_numeric(dfsub[col_name])

#answer questions 
#Question 3: Percentage of reads supporting the variant versus those supporting reference reads
    dfsub['Q3A'] = (dfsub['col9'] / dfsub['col8']) * 100
#Question 3 continued: versus those supporting reference reads
    dfsub['Q3B'] = 100 - dfsub['Q3A']
#Question 6: Thought coverage adjusted for size of the region in the reference, where coverage = number of reads/ bp length of window
#df['col10'] = df[7] / df[4].str.len()

    string_length = dfsub.iloc[:, 4].str.len()
    dfsub['StringLength'] = string_length
    dfsub['Q6'] = dfsub['col9']/dfsub['StringLength']

    dfsub1=dfsub.iloc[:,np.r_[0:6,8:11,12]]

# Save the processed DataFrame to the output file
    dfsub1.to_csv(output_file1, sep='\t', index=False, header=False)

if __name__ == '__main__':
    main()

