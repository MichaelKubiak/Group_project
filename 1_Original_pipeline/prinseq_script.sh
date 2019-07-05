#to run through every subfolder of files within a folder
suffix="/home/rsk17/Group_project/1_Original_pipeline/scpipe_testing/"
for i in /home/rsk17/Group_project/1_Original_pipeline/scpipe_testing/*
do
#two run through both files within a folder
	one="_1.fastq.gz"
	two="_2.fastq.gz"
	echo this $i
	j=${i#$suffix}
	one=$i"/"$j$one
	two=$i"/"$j$two
	echo "file $one"
	echo "file $two"


#prinseq two files within a folder to remove short reads, trim the first 10bp on 5' end, trim reads with low quality on 3' end, filter low complexity reads (lc_method entropy and lc_theshold 65 are outdated for this version of prinseq) threads can be alter
	prinseq++ -fastq $one -fastq2 $two -min_len 30 -trim_left 10 -trim_qual_right 25 -lc_entropy 0.65 -threads 3 -out_name $j -out_bad /dev/null/ -out_bad2 /dev/null/ -out_single /dev/null/ -out_single2 /dev/null/

#using the fastqc results  from the command line command:  fastqc file.fastq.gz whcih produces a zip file within each result file, the results from these could be used for cutadapt to remove the overrepresented sequences and the nextera adaptors

#download fastqc
# runs through the subfolders within a the same folder to run fastqc which automatically zips the files

	a="_good_out_R1.fastq"
	b="_good_out_R2.fastq"

	fastqc $j$a $j$b --extract -t 3
	#gunzip $j$a$_fastqc.zip $j$b$_fastqc.zip

done


