"""
Parallelised
"""

import gzip
import shutil
import os
from multiprocessing import Pool
from functools import partial


def barcoding(entity, files_done, files_to_do):
    filename = entity.split(".")
    filename = filename[0] + ".fastq"
    print(filename + "\n")
    if entity.endswith(".gz"):
        with gzip.open(entity, "rb") as f:
            for lines in f:
                with open(filename, "a+") as h:
                    lines = str(lines)
                    lines = lines.lstrip("b'").rstrip("\n")
                    lines += "\n"
                    if not (lines.startswith("@SRR") or lines.startswith("+")):
                        string = "TRUE" + lines
                        h.writelines(string)
                    else:
                        h.writelines(lines)

        outfile = filename + ".gz"
        with open("done_files.txt", "a+") as p:
            p.write(outfile + "\n")

        with open(filename, 'rb') as f_in, gzip.open(filename + '.gz', 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
            f_out.close()
            f_in.close()
        gzip_filename = filename + ".gz"
        os.rename(gzip_filename, "Barcoded/" + gzip_filename)
        os.remove(filename)
        files_done += 1


def barcoding_mp(entities, files_done, files_to_do):
    p = Pool()
    result = p.map(partial(barcoding, files_done=files_done, files_to_do=files_to_do), files)
    p.close()
    p.join()


if __name__ == "__main__":
    files = os.listdir(".")
    print(files)

    files_done = 1
    files_to_do = len(files)

    barcoding_mp(files, files_done, files_to_do)

    with open("done.done", "a") as z:
        z.write("done")
        print("done")
        z.close()








