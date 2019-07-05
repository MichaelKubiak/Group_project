"""
scpipe must be executed 466 times, one for each cell
This script will execute the scPipe R script for each pair of reads into a named directory
"""
import os
import sys
import subprocess
import argparse

SRR_acc_filepath = "/home/izzy_r/Group_project/Project_repo/Group_project/Scripts/SRR_testing.txt"
if os.path.isfile(SRR_acc_filepath):
    print("SRR accession file located.")

else:
    sys.exit("ERROR: no SRR accession file located. Check the path and try again.")

with open(SRR_acc_filepath) as SRR_accs:
    SRR_acc_list = SRR_accs.readlines()

# for accession in SRR_acc_list:
#     accession = accession.replace("\n", "")
#     if os.path.exists(accession):
#         print("using available directory", accession)
#     else:
#         os.mkdir(accession)

R_script = "/home/izzy_r/Group_project/Project_repo/Group_project/2_Alternative_pipeline/scPipe/multicell_testing.R"
file1 = "/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/Test_fastq/SRR1974698_1.fastq"
file2 = "/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/Test_fastq/SRR1974698_2.fastq"
SRR_1 = SRR_acc_list[0].strip("\n")

# example subprocess with arguments
subprocess.run(["Rscript", R_script, "--SRR", SRR_1])



# scPipe.R --file1 = SRRXXXXXXX_1.fastq.gz --file2 = SRRXXXXXXX_2.fastq.gz
