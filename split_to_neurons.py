#! /usr/bin/env python3
import re

with open("SraRunTable_all.txt") as runs:
    runinfo = runs.readlines()

with open("adult_cells") as datafile:
    data = datafile.readlines()

sample_names = []
types = []

for run in runinfo:
    sample_names.append(run.split("\t")[9])
    types.append(run.split("\t")[12])

neuron_list = []
for i in range(len(sample_names)):

    if (re.search("neuron", types[i])):
        neuron_list.append(sample_names[i])


neuron = []


for line in data:
    neuron.append(line.split("\t")[0])
split_names = data[0].split("\t")

for j in range(len(split_names)):
    if split_names[j].split("_")[0] in neuron_list:
        for i in range(len(data)):
            neuron[i] += "\t" + data[i].split("\t")[j]
for i in range(len(neuron)):
    if not neuron[i].endswith("\n"):
        neuron[i] += "\n"
with open("neurons", "w") as out:
    out.writelines(neuron)
