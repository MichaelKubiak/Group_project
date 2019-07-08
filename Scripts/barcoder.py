#comma deliniated with a header

import gzip
with gzip.open("SRR1974543_1.fastq.gz", "rb") as f:
    for lines in f:
        if lines.startswith(@ or +):
            print(lines)