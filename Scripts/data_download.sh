#!/bin/bash
input="/home/izzy_r/Group_project/Project_repo/Group_project/SRR_Acc_List.txt"
while IFS= read -r line
do 
	"/home/izzy_r/Group_project/Project_repo/Group_project/sratoolkit.2.9.6-1-ubuntu64/bin/fastq-dump" -O "/home/izzy_r/Group_project/Project_repo/Group_project/DATA_fastQ/" "$line"
	echo "Downloading $line file"
done <"$input"


