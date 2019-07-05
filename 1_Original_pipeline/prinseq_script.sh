
suffix="/home/rsk17/Group_project/1_Original_pipeline/scpipe_testing/"
for i in /home/rsk17/Group_project/1_Original_pipeline/scpipe_testing/*
do
	one="_1.fastq.gz"
	two="_2.fastq.gz"
	echo this $i
	j=${i#$suffix}
	one=$i"/"$j$one
	two=$i"/"$j$two
	echo "file $one"
	echo "file $two"



	prinseq++ -fastq $one -fastq2 $two -min_len 30 -trim_left 10 -trim_qual_right 25 -lc_entropy 0.65 -threads 3 -out_name $j -out_bad /dev/null/ -out_bad2 /dev/null/ -out_single /dev/null/ -out_single2 /dev/null/

# ./trim_galore -e 0.15 -length 30 ~/Group_project/1_Original_pipeline/$j_good_out_R1.fastq 


done


