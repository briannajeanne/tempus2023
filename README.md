# tempus2023
###------------------------------------Pipeline README—------------------------------------------### <br>
###----------------------Introduction   
   
The runner.sh is a bash script that calls bbixler_script1.py, bbixler_script2.sh, bbixler_script3.r, bbixler_script4.sh, bbixler_script5.sh in a reproducible way and with as few variable inputs as possible. Please make sure all the bbixler scripts are in the same directory. 
  
You will only need to run the runner.sh script once to get all the relevant intermediate files and the final output. Hopefully this will make things easier. I prefer to approach each question with an individual script and debug that independently of any other step so I can work on them all at the same time. A single question will occasionally have 2 scripts because I needed to switch languages. Each individual script should have a help menu with an example of usage, and there is a log file named runner.log that stores the individual commands executed by the runner script. 
   
Answers to questions:    
1. Depth of sequence coverage at the site of variation.    
For this, I used the TC output in the info field of the platypus VCF file to represent what this program identifies as total coverage at this locus. I noticed that TC was consistently equal to NR, number of reads covering variant position in this sample, even when the locus was more than one base pair long. Because of this, I added a re-calculated coverage that accounts for window size as my answer to question 6. Isolated by the bbixler_script1.py script and stored in the step1.tab file. 
   
2. Number of reads supporting the variant   
I used the NV, number of reads at variant position which support the called variant in this sample, variable in the format field of the platypus file directly for this. Isolated by the bbixler_script1.py script and stored in the step1.tab file. 
   
3. Percentage of reads supporting the variant versus those supporting reference reads.   
I first calculated the percentage of reads supporting the variant, then subtracted this from 100 assuming that the two are mutually exclusive. I recognize this might not always be the case in the instances of 3rd or 4th bp but this was the closest estimate that I could offer without access to the raw reads. For this I divided NV, Number of reads at variant position which support the called variant in this sample, by NR, Number of reads covering variant position in this sample. I added another column that was 100-(NV/NR).  Isolated by the bbixler_script1.py script and stored in the step1.tab file. 
   
4. Using the VEP hgvs API, get the gene of the variant, type of variation (substitution,
insertion, CNV, etc.) and their effect (missense, silent, intergenic, etc.). The API
documentation is available here: https://rest.ensembl.org/#VEP
https://www.youtube.com/watch?v=i1dHq8DdeVQ.    
This was a journey to get up and running with the finickiness of BioPerl. I ran the –cache version of the API with the –variant_class option. This was executed by bbixler_script4.sh and stored in step4_vep.txt. 
   
6. The minor allele frequency of the variant if available.   
I used the bcftools/vcftools to generate a handful of intermediate files that ended up being uninformative for this file (though not typically). One of these outputs was the step2.frq generated from vcftools –freq2 option that calculates allele frequency without filtering. This in combination with bbixler_script3.r generated the maf scores that were saved in step3_maf.tab file. 
   
8. Any additional annotations that you feel might be relevant.   
As mentioned in question 1, I noticed total coverage and number of reads were equal for every row, even for rows that the reference sequence was more that 1 nucleotides long. Therefore, I calculated an alternative coverage score that is NV/str.length(reference_sequence). This was calculated in bbixler_script1.py and stored in step1.tab. 
   
###-----------------------Usage    
To use this pipeline, follow the instructions below:

###-----------------------Prerequisites    

Before running the pipeline, make sure you have the following prerequisites:

   Bash shell environment
   Bcftools
   Vcftools 
   Python3, including packages pandas and requests 
   R, including dplyr package
   VEP (Variant Effect Predictor) installed and configured

###--------------------------Installation notes     
Python packages:   
     pip install pandas   
     pip install requests    
Commandline tools:      
     sudo apt install bcftools   
     sudo apt install vcftools    
R packages:    
     install.packages("dplyr")   

VEP resources:   
    https://stackoverflow.com/questions/70324825/failing-to-install-vep-dependencies
    https://github.com/Ensembl/ensembl-vep/issues/149



###---------------------Running the Pipeline

You can run the pipeline by executing the main script with the following command on the commandline: 
    
    ./runner.sh [options] <input_file> <output_prefix> <path_to_vep_script> <path_to_vep_cache> [path_to_scripts]

Options:

    -h, --help: Show this help message and exit.

Arguments:

    <input_file>: Input data file for the pipeline.
    <output_prefix>: Prefix for naming output files.
    <path_to_vep_script>: Path to the VEP (Variant Effect Predictor) script.
    <path_to_vep_cache>: Path to the VEP cache directory.
    [path_to_scripts] (optional): Path to additional custom scripts (with or without "/" at the end). Defaults to the current directory.

###---------------------------- Example

Here's an example of how to run the pipeline    
    
    ./runner.sh [options] test_data_vcf.txt out_091823 /path/to/vep /path/to/vep/cache /path/to/directory/of/bbixler_scripts/
    
    

###-------------------------------Pipeline Steps
The pipeline consists of the following steps:

1. Reformat vcf and isolate columns of interest with bbixler_script1.py   
2. Generate QC files with vcftools and calculate allele frequency with bbixler_script2.sh.   
3. Reformat and filter allele frequencies to get column of maf values with bbixler_script3.r.   
5. Run through VEP API with and reformat to join bbixler_script4.sh   
5. Reformat and sort to join files and ultimately generate the final output in a tab-separated format using bbixler_script5.sh.   

###----------------------------------Output   

The final processed data will be saved as bbixler_output_prefix_final.tab, where output_prefix is the prefix provided during execution with a header that signals to the question being answered in each column. 

###-------------------- Notes   

Please ensure that all required dependencies, scripts, and data files are in place before running the pipeline. Also chmod +x each script and make sure that all the scripts are within in same directory. 

###-------------------- And a final note   
Thanks so much for the opportunity to apply! I look forward to hearing your feedback!    
Brianna Jeanne Bixler     
18 Sept 2023   

