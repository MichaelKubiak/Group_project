#comma deliniated with a header

import gzip
import shutil
import os
from multiprocessing import Pool
from functools import partial



def barcoding(entities, files_done, files_to_do):
    if entities.endswith(".gz"):
        with gzip.open(entities, "rb") as f:
            file_content = f.readlines()
            f.close()


        fastq_list = []
        print("starting file:", str(files_done))
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
        print(filename)

        with open(filename,"w") as h:
            h.writelines(fastq_list)
            h.close()


        with open(filename, 'rb') as f_in, gzip.open(filename + '.gz', 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
            f_in.close()
            f_out.close()

        os.remove(filename)
        print("files:", files_done, "/", files_to_do)
        files_done += 1


def barcoding_mp(entities, files_done, files_to_do):
    p = Pool()

    result = p.map(partial(barcoding, files_done=files_done, files_to_do=files_to_do), files)

    p.close()
    p.join()


if __name__ == "__main__":


    dir_path = "/home/tsc21/Documents/BS7120/Group_project/scPipe/Test/"
    files = os.listdir(dir_path)
    print(files)

    files_done = 1
    files_to_do = len(files)


    barcoding_mp(files,files_done,files_to_do)








