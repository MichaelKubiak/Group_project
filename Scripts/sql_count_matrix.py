import argparse

# Argparse for user options and help
parser = argparse.ArgumentParser(description='Convert gene expression matrix to SQL friendly format')
parser.add_argument("input", help='input a tab delineated gene expression matrix')
parser.add_argument('--output', help='manually set output path', default=".")
args = parser.parse_args()

#
with open(args.input) as matrix:
    data = matrix.readlines()

cell_names = data[0].rstrip("\n").split("\t")
cell_IDs = []
for name in cell_names:
    if len(name) > 1:
        name = name[:10]
        cell_IDs.append(name)

gene_IDs = []
expression_data_rows = []
for line in data[1:]:
    line = line.split("\t")
    gene_IDs.append(line[0])
    expression_data_rows.append(line[1:])

output = "sql_expression_table"

expr = ""

for line in data[1:]:
    line = line.strip("\n")
    line = line.split("\t")
    gene = line[0]
    numbers = line[1:]
    print(numbers[464])
    for i in range(len(numbers)):
        if int(numbers[i]) != 0:
            with open(args.output, "a+") as out:
                out.write(gene + "\t" + cell_IDs[i] + "\t" + numbers[i] + "\n")
