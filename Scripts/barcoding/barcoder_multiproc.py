"""
Parallelised barcoding script for use in scPipe analysis. (This was not used due to a move to Rsubread)
Script is slow but becomes effective on high core number machines.
Else, use classic barcoder.py (high memory consumption)
Usage: Run the script in the directory with Gzipped fastq files that require an artificial barcode to be added
"""

import gzip
import shutil
import os
from multiprocessing import Pool
from functools import partial

# Barcoding function to be called from multiproc pool
def barcoding(entity, files_done, files_to_do):
    # remove .gz from the filename
    filename = entity.split(".")
    filename = filename[0] + ".fastq"
    # Print file started
    print(filename + "\n")
    if entity.endswith(".gz"):
        # open the input file
        with gzip.open(entity, "rb") as f:
            for lines in f:
                # create/append output file and add barcode to data lines in the file
                with open(filename, "a+") as h:
                    lines = str(lines)
                    lines = lines.lstrip("b'").rstrip("\n")
                    lines += "\n"
                    if not (lines.startswith("@SRR") or lines.startswith("+")):
                        string = "TRUE" + lines
                        h.writelines(string)
                    else:
                        h.writelines(lines)

        # log completed files
        outfile = filename + ".gz"
        with open("done_files.txt", "a+") as p:
            p.write(outfile + "\n")

        # Copy the barcoded file into a completed file directory
        with open(filename, 'rb') as f_in, gzip.open(filename + '.gz', 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
            f_out.close()
            f_in.close()
        os.rename(outfile, "Barcoded/" + outfile)
        os.remove(filename)
        files_done += 1
        print(str(files_done) + " files completed")

# Call barcoding using pool from multiprocessing
def barcoding_mp(entities, files_done, files_to_do):
    p = Pool()
    p.map(partial(barcoding, files_done=files_done, files_to_do=files_to_do), files)
    p.close()
    p.join()

# Run the functions on the files in the working directory
if __name__ == "__main__":
    files = os.listdir(".")
    print(files)

    files_done = 1
    files_to_do = len(files)
    print("files to do:", files_to_do)
    barcoding_mp(files, files_done, files_to_do)

    with open("done.done", "a") as z:
        z.write("done")
        print("done")
        z.close()








