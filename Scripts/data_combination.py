#! /usr/bin/env python3
import os


# function to add the second column of a list produced from readlines() on a tab separated file to a list from the same type of file
def add_to_lines(starting_lines, added_lines):
    # loop through the original list
    for j in range(1, len(starting_lines)):
        # strip the newline character from the line in the original list
        starting_lines[j] = starting_lines[j].strip("\n")
        #split the line from the list to be added by tabs
        split_line = added_lines[j-1].split("\t")
        # append the 2nd column of the file to the lines of the original file
        starting_lines[j] += "\t" + split_line[1]
    return starting_lines


lines = []
i = 0
files = os.listdir(".")

# for each file found
for file in files:
    # check that it is the correct type of file
    if file.endswith(".csv"):
        # open the file such that it will be safely closed
        with open(file) as nextcsv:
            # if this is the first file
            if(i == 0):
                # put the file name at the top of the column
                lines.append("\t" + file)
                # add everything in the file to the lines list (including the row names)
                lines += nextcsv.readlines()
                print(lines)

            else:
                lines[0] += "\t" + file
                # read the file into a list
                nextlines = nextcsv.readlines()
                # add the second column of the file to the correct lines in the lines list
                lines = add_to_lines(lines, nextlines)
        i += 1
lines[0] += "\n"
# open the output file to write the output
with open("combined_data", "w") as output:
    output.writelines(lines)


