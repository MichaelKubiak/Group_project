#comma deliniated with a header

import gzip
import re



with gzip.open("SRR1974543_2.fastq.gz", "rb") as f:
    file_content = f.readlines()

#with open("SRR1974543_1.fastq") as g:
#    something = g.readlines()

fastq_list = []

for lines in file_content:
    lines = str(lines)
    lines = lines.lstrip("b'")
    lines = lines.rstrip("\n'")
    lines += "\n"
    if not (lines.startswith("@") or lines.startswith("+")):
        string = "TRUE" + lines
        fastq_list += string
    else:
        fastq_list += lines


with open("cell1.2.fastq","w") as h:
    h.writelines(fastq_list)
