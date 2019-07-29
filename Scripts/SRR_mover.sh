#!/bin/bash
# copy a certain number of files to a new location (used for splitting data for data processing)
input="/home/izzy_r/Group_project/Project_repo/Group_project/Scripts/SRR_1_acc_list.txt"
while IFS= read -r line
do
    "cp" "$line"* "FirstHalf/."
	
	echo "file copied to new directory"
done <"$input"
