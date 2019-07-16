import argparse

# Argparse for user options and help
parser = argparse.ArgumentParser(description='Convert gene expression matrix to SQL friendly format')
parser.add_argument("input", help='input a tab delineated gene expression matrix')
parser.add_argument('--output', help='manually set output path', default=".")
args = parser.parse_args()

# Read in the input gene count matrix
with open(args.input) as matrix:
    data = matrix.readlines()

# Process the first row which contains all the cell names
cell_names = data[0].rstrip("\n").split("\t")
cell_IDs = []
for name in cell_names:
    if len(name) > 1:
        name = name[:10]
        cell_IDs.append(name)

# process and write each expression data point from the remaining rows alongside gene and cell information
for line in data[1:]:
    line = line.strip("\n")
    line = line.split("\t")
    gene = line[0]
    numbers = line[1:]
    print("working.....", numbers[464]) # print statement with variable end number so user can see visual progress
    for i in range(len(numbers)):
        if int(numbers[i]) != 0:
            with open(args.output, "a+") as out:
                out.write(gene + "\t" + cell_IDs[i] + "\t" + numbers[i] + "\n")

print("File creation completed.")
