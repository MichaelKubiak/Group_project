#comma deliniated with a header

import gzip
<<<<<<< HEAD
with gzip.open("SRR1974543_1.fastq.gz", "rb") as f:
    for lines in f:
        if lines.startswith(@ or +):
            print(lines)
=======
import shutil
import os

files = os.listdir("/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/Test_fastq")

files_done = 0
for entities in files:
    if entities.endswith(".gz"):
        with gzip.open(entities, "rb") as f:
            file_content = f.readlines()

        fastq_list = []
        files_to_do = len(files)
        print("starting file:", str(files_done + 1))
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

        filename = entities.split(".")
        filename = filename[0] + ".fastq"

        with open(filename,"w") as h:
            h.writelines(fastq_list)



        with open(filename, 'rb') as f_in, gzip.open(filename + '.gz', 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
        os.remove(filename)
        files_done += 1
        print("files:", files_done, "/", files_to_do)

>>>>>>> 0c4ca9aa8f3f227ab77b75c62c7561772387ad58
