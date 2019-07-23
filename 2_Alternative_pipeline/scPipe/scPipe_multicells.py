"""
Execute scpipe R script multiple times for a list of accession numbers
This script will execute the scPipe R script for each pair of reads into a named directory.
Outputs from the script appear where your working directory is.
Before use configure the path for R_script to match your path, as well as any relevant paths in the R script.
"""
import os
import sys
import subprocess
import argparse

def move_index():
    os.rename("read_index.00.b.array", "../Index/read_index.00.b.array")
    os.rename("read_index.00.b.tab", "../Index/read_index.00.b.tab")
    os.rename("read_index.files", "../Index/read_index.files")
    os.rename("read_index.log", "../Index/read_index.log")
    os.rename("read_index.reads", "../Index/read_index.reads")


# Argparse for user SRA accession list input
parser = argparse.ArgumentParser(description='Combine cell data info into the header of the gene expression matrix')
parser.add_argument("SRR_acc_list", help='input a text file containing SRR accessions separated by newlines (this can '
                                         'be downloaded from the SRA website when obtaining data')
parser.add_argument('--index', help='set to True to rebuild an index if it has not been built or the reference '
                                    'genome has been changed', default=False)
args = parser.parse_args()

# User input for building the reference index True/ False
rebuild_index = args.index
print(rebuild_index)
# Link the R script the code is designed to run here
R_script = "/home/izzy_r/Group_project/Project_repo/Group_project/2_Alternative_pipeline/scPipe/multicell_testing.R"

# Collect the accession numbers the FASTQ data is downloaded from
SRR_acc_filepath = args.SRR_acc_list

# Find and process the accession list provided by the user
if os.path.isfile(SRR_acc_filepath):
    print("SRR accession file located.")
else:
    sys.exit("ERROR: no SRR accession file located. Check the path and try again.")
with open(SRR_acc_filepath) as SRR_accs:
    input_lines = SRR_accs.readlines()

# Removing newlines
SRR_acc_list = []
for line in input_lines:
    if len(line) > 1:
        SRR_acc = line.rstrip("\n")
        SRR_acc_list.append(SRR_acc)

# Check for broken accessions.
count = 0
miscount = 0
for acc in SRR_acc_list:
    if len(acc) != 10 and not acc.startswith("SRR"):
        miscount += 0
        print("erroneous SRR detected:", acc)
    else:
        count += 1
print("SRR file appears to contain", str(count), "accessions. Beginning scPipe analysis")


# Running the R script:

# totals for progress messages
total_accessions = len(SRR_acc_list)
acc_number = 1

# Create SRR named directory where necessary
for accession in SRR_acc_list:
    # Stop subsequent inputs from building index if first run requires it
    if acc_number > 1:
        rebuild_index = False
    # Create R boolean strings:
    if rebuild_index:
        Rindex = "T"
    else:
        Rindex = "F"
    remaining_accessions = total_accessions - acc_number
    print("Beginning analysis for:", accession)

    if os.path.exists(accession):
        print("using available directory", accession)
    else:
        os.mkdir(accession)
    # Move to the accession directory
    os.chdir("./" + accession)
    # Run the R script with accession number for prefixes (See multicell_testing.R for further information)
    subprocess.run(["Rscript", R_script, "--SRR", accession, "--build_index", Rindex])
    # Remove large files that are not required
    os.remove(accession + "combined_fastq.gz")
    os.remove(accession + "out.map.bam")
    os.remove(accession + "out.aln.bam")
    gene_count_out = accession + "gene_count.csv"
    os.rename("gene_count.csv", gene_count_out)
    print("Completed", acc_number, "of", total_accessions, ". remaining accessions:", remaining_accessions)
    if rebuild_index and acc_number == 1:
        move_index()
    os.chdir("../")
    acc_number += 1

print("scPipe analysis completed.")
