#! /usr/bin/env python3
import re

with open("SraRunTable_all.txt") as runs:
    runinfo = runs.readlines()

with open("combined_data") as datafile:
    data = datafile.readlines()

sample_names = []
ages = []

for run in runinfo:
    sample_names.append(run.split("\t")[9])
    ages.append(run.split("\t")[10])

adult_list = []
child_list = []
for i in range(len(sample_names)):

    if (re.search("postnatal",ages[i])):
        adult_list.append(sample_names[i])
    elif(re.search("prenatal",ages[i])):
        child_list.append(sample_names[i])

adult = []
child = []


for line in data:
    adult.append(line.split("\t")[0])
    child.append(line.split("\t")[0])
split_names = data[0].split("\t")

for j in range(len(split_names)):
    if split_names[j].split("_")[0] in adult_list:
        for i in range(len(data)):
            adult[i] += "\t" + data[i].split("\t")[j]
    elif split_names[j].split("_")[0] in child_list:
        for i in range(len(data)):
            child[i] += "\t" + data[i].split("\t")[j]
for i in range(len(adult)):
    if not adult[i].endswith("\n"):
        adult[i] += "\n"
    if not child[i].endswith("\n"):
        child[i] += "\n"
with open("adult_cells", "w") as aout:
    aout.writelines(adult)

with open("foetal_cells", "w") as cout:
    cout.writelines(child)

