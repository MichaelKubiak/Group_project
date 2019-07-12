# Add in an artificial barcode to each fastQ file for scPipe to work on not quite 'raw' data.

import gzip
import shutil
import os

# import a list of files
files = os.listdir(".")


files_done = 0
files_to_do = len(files)
for entity in files:
    filename = entity.split(".")
    filename = filename[0] + ".fastq"
    if entity.endswith(".gz"):
        print(entity)
        # with gzip.open(entities, "rb") as f:
        #     file_content = f.readlines()
        #     f.close()

        fastq_list = []
        print("starting file:", str(files_done + 1), filename)
        with gzip.open(entity, "rb") as f:
            for lines in f:
                with open(filename, "a+") as h:
                    lines = str(lines)
                    lines = lines.lstrip("b'")
                    lines = lines.rstrip("\n'")
                    lines += "\n"
                    if not (lines.startswith("@SRR") or lines.startswith("+")):
                        string = "TRUE" + lines
                        h.writelines(string)
                    else:
                        h.writelines(lines)

        # with open(filename, "w") as h:
        #     h.writelines(fastq_list)
        #     h.close()

        outfile = filename + ".gz"
        with open("done_files.txt", "a") as p:
            p.write(outfile + "\n")

        with open(filename, 'rb') as f_in, gzip.open(filename + '.gz', 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
            f_out.close()
            f_in.close()
        gzip_filename = filename + ".gz"
        os.rename(gzip_filename, "Barcoded/" + gzip_filename)
        os.remove(filename)

        files_done += 1
        print("files:", files_done, "/", files_to_do)
