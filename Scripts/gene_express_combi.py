"""
merge cell data into header of gene expression matrix given a metadata file
usage 'python3 2_Alternative_pipeline/SraRunTable_all.txt combined_data.txt' when run in project directory
"""

import argparse
# Argparse setup to take input filename as required argument
parser = argparse.ArgumentParser(description='Combine cell data info into the header of the gene expression matrix')
parser.add_argument("metadata", help='input experimental metadata file')
parser.add_argument("exp_matrix", help='input gene expression matrix')
args = parser.parse_args()

# get filenames from user input
metadata_file = args.metadata
matrix_file = args.exp_matrix

# Read in the input files
with open(metadata_file) as meta:
    metadata = meta.readlines()
with open(matrix_file) as mat:
    matrix = mat.readlines()

# Create a dictionary of GSM ids and cell types from the metadata file (exclude header from dict)
data_dict = {}
for row in metadata[1:]:
    data = row.split("\t")
    GSM = data[9]
    cell_type = data[12]
    data_dict[GSM] = cell_type


# save the cell names in the order of the matrix file
cell_names = []
header = matrix[0]
header_names = []
header_list = header.split("\t")
for item in header_list:
    header_name = item[0:10]
    header_names.append(header_name)

# Merge the new header names using the dictionary
output_header = []
for item in header_names:
    if len(item) > 1:
        output_header.append(item + "_" + data_dict[item])
print(output_header)

# Write output file
# Add header with formatting then add the rest of the data back
with open("gene_name_output.txt", "w") as output:
    output.write("\t")
    for item in output_header:
        output.write(item + "\t")
    output.write("\n")
    for line in matrix[1:]:
        output.write(line)
