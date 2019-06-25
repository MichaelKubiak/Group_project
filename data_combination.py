#! /usr/bin/env python3
import os


def add_to_lines(starting_lines, added_lines):
    for j in range(len(starting_lines)):
        starting_lines[j] = starting_lines[j].strip("\n")
        split_line = added_lines[j].split("\t")
        starting_lines[j] += "\t" + split_line[1]
    return starting_lines


lines = []
i = 0

for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".csv"):

            with open(file) as nextcsv:
                if(i == 0):
                    lines = nextcsv.readlines()
                else:
                    nextlines = nextcsv.readlines()
                    lines = add_to_lines(lines, nextlines)
            i += 1

with open("combined_data", "w") as output:
    output.writelines(lines)



