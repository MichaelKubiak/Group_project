#! /usr/bin/env python3

# ---------------------------------------------------------------------------------------------------------------
# Script to separate out a specific subset of tsv dataset based on values in a specified column of an information table
# ---------------------------------------------------------------------------------------------------------------

import argparse
import re

parser = argparse.ArgumentParser(description="Script to separate out a specific subset of a dataset based on values in "
                                             "a specified column of a separate information table about that dataset")
parser.add_argument("dataset", help="The tsv file to be split")
parser.add_argument("information", help="The file containing a table with information about the dataset")
parser.add_argument("--name_column", "-n", required=True, help="The name column containing the names of the samples")
parser.add_argument("--split_column", "-s", required=True, help="The name of the column to be used for splitting")
parser.add_argument("--values", "-v", required=True, nargs="*", help="The values found in that column corresponding to rows"
                                              " to be placed in new files")
parser.add_argument("--output", "-o", nargs="*", help="Output file names")

args = parser.parse_args()

# open files
with open(args.dataset) as datafile:
    data = datafile.readlines()

with open(args.information) as runs:
    runinfo = runs.readlines()

# find split column's index and the name column's index
columns = runinfo[0].split("\t")
split_column = 0
name_column = 0

for i in range(len(columns)):
    if columns[i] == args.split_column:
        split_column = i
    elif columns[i] == args.name_column:
        name_column = i

# get the contents of the name column and the split column
sample_names = []
split_values = []

for run in runinfo:
    sample_names.append(run.split("\t")[name_column])
    split_values.append(run.split("\t")[split_column])

# produce a list containing lists of the names of the samples in each group, secondly, produce a list containing each l
names_in_groups = []
line_groups = []

for j in range(len(args.values)):
    names_in_groups.append([])
    line_groups.append([])
    for i in range(len(sample_names)):

        if re.search(args.values[j], split_values[i]):
            names_in_groups[j].append(sample_names[i])

    for line in data:
        # add all lines of data for each sample to the lists for those groups
        line_groups[j].append(line.split("\t")[0])

split_names = data[0].split("\t")
for k in range(len(names_in_groups)):
    for j in range(len(split_names)):
        if split_names[j].split("_")[0] in names_in_groups[k]:
            for i in range(len(data)):

                line_groups[k][i] += "\t" + data[i].split("\t")[j]

for j in range(len(line_groups)):
    for i in range(len(line_groups[j])):
        if not line_groups[j][i].endswith("\n"):
            line_groups[j][i] += "\n"
    if args.output[j]:
        with open(args.output[j], "w") as output:
            output.writelines(line_groups[j])
    else:
        with open(args.dataset + "_" + args.values[j], "w") as output:
            output.writelines(line_groups[j])


