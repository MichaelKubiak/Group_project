#comma deliniated with a header

import gzip
import re



<<<<<<< HEAD
for entities in files:
    if entities.endswith(".gz"):
        with gzip.open(entities, "rb") as f:
            file_content = f.readlines()
            f.close()
=======
with gzip.open("SRR1974543_2.fastq.gz", "rb") as f:
    file_content = f.readlines()
>>>>>>> parent of c2ddd11... new_barcode_file

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


<<<<<<< HEAD
        with open(filename,"w") as h:
            h.writelines(fastq_list)
            h.close()


        with open(filename, 'rb') as f_in, gzip.open(filename + '.gz', 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
            f_out.close()
=======
with open("cell1.2.fastq","w") as h:
    h.writelines(fastq_list)
>>>>>>> parent of c2ddd11... new_barcode_file
