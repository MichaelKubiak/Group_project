"""
scpipe must be executed 466 times, one for each cell
This script will execute the scPipe R script for each pair of reads into a named directory
"""

SRR_acc_filename = "SRR_Acc_List.txt"
with open(SRR_acc_filename) as SRR_accs:
    SRR_acc_list = SRR_accs.readlines()

for accession in SRR_acc_list:
    print(accession)
