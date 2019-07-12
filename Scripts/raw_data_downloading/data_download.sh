#!/bin/bash
# This is a slow method of downloading fastQ files from SRA run data. It is more efficient to use the perl script gerthmicha_sra_download.pl but if files are only available on SRA this may be a viable alternative for small datasets.
input="/home/izzy_r/Group_project/Project_repo/Group_project/SRR_Acc_List.txt"
while IFS= read -r line
do 
	"/home/izzy_r/Group_project/Project_repo/Group_project/sratoolkit.2.9.6-1-ubuntu64/bin/fastq-dump" -O "/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/" "$line"
	echo "Downloaded $line file"
done <"$input"


