"""
extracts the relevant rows from a full sraRunTable based on the test data matrix generated from the selected samples.
Used if not using sc3 pipeline on all 466 cells
usage example 'python3 2_Alternative_pipeline/SraRunTable_all.txt test_combined_data' when run in project directory

"""

import argparse
# Argparse setup to take input filename as required argument
parser = argparse.ArgumentParser(description='Combine cell data info into the header of the gene expression matrix')
parser.add_argument("metadata", help='input full experimental metadata file')
parser.add_argument("test_matrix", help='input gene expression matrix')
args = parser.parse_args()

# get filenames from user input
metadata_file = args.metadata
matrix_file = args.test_matrix

# Read in the input files
with open(metadata_file) as meta:
    metadata = meta.readlines()
with open(matrix_file) as mat:
    matrix = mat.readlines()

# Create a list of GSM identifiers based on test matrix header:
GSM_ids = []
matrix_header = matrix[0].split("\t")
for id in matrix_header:
    GSM_ids.append(id[0:10])

# identify which sample names are in "sample name" in metadata
saved_lines = []
for line in metadata[1:]:
    split_line = line.split("\t")
    if split_line[9] in GSM_ids:
        saved_lines.append(line)
print(saved_lines[0])

# Write the output file
with open("test_sra_run.txt", "w") as output:
    # write the header first:
    output.write(metadata[0])
    # write in saved lines:
    for line in saved_lines:
        output.write(line)
