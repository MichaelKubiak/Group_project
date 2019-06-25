import os

lines = []
i = 0
for root, dirs, files in os.walk(".."):
    for file in files:
        if file.endswith(".csv"):

            with open(file) as nextcsv:
                if(i == 0):

                    lines = nextcsv.readlines()
                else:
                    nextlines = nextcsv.readlines()
                    for j in range(len(lines)):
                        lines[j] = lines[j].strip("\n")
                        split_line = nextlines[j].split("\t")
                        lines[j] += "\t" + split_line[1]
            i += 1

print(lines)
with open("combined_data","w") as output:
    output.writelines(lines)
