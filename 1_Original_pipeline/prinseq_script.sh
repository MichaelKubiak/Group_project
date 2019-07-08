#to run through every subfolder of files within a folder
#where the raw data files are located within a directory
raw_data="/home/rsk17/Group_project/1_Original_pipeline/scpipe_testing/"
#loops through files within the named directory
for i in /home/rsk17/Group_project/1_Original_pipeline/scpipe_testing/*
do
#two run through both files within a folder
#pair read suffixes
	one="_1.fastq.gz"
	two="_2.fastq.gz"
	echo this $i
	j=${i#$raw_data}
	one=$i"/"$j$one
	two=$i"/"$j$two
	echo "file $one"
	echo "file $two"


#prinseq++ on two fastq files within a folder to remove short reads, trim the first 10bp on 5' end, trim reads with low quality on 3' end, filter low complexity reads (lc_method entropy and lc_theshold 65 are outdated for this version of prinseq) threads can be alter
	prinseq++ -fastq $one -fastq2 $two -min_len 30 -trim_left 10 -trim_qual_right 25 -lc_entropy 0.65 -threads 3 -out_name $j -out_bad /dev/null/ -out_bad2 /dev/null/ -out_single /dev/null/ -out_single2 /dev/null/

#using the fastqc results  from the command line command:  fastqc file.fastq.gz whcih produces a zip file within each result file, the results from these could be used for cutadapt to remove the overrepresented sequences and the nextera adaptors

#download fastqc
# runs through the subfolders within a the same folder to run fastqc which automatically zips the files

	a="_good_out_R1.fastq"
	b="_good_out_R2.fastq"
	
	fastqc $j$a $j$b --extract -t 3
	
	c="_good_out_R1_fastqc"
	d="_good_out_R2_fastqc"
	

	python3 fadapa1.py $j$c


	#overp1=python3 fadapa1.py $j$c #command not found but still does cutadapt ish
	#python3 fadapa1.py $j$d
	cutadapt -overrep_seq.txt -e 0.15 -m 30 -o trimmedR1$j.fastq $j$a
#	cutadapt $overp2 -e 0.15 -m 30 -o trimmedR2$j.fastq $j$b
# $j$c python3 fadapa1.py $j$c -e 0.15 -m 30 -
	#python3 fadapa1.py $j$d
#cutadapt needs to be input into prinseq and STAR
#-e 0.15 -m 30

#re trim for orphan reads
#	prinseq++ -min_len 30 -fastq ... -fastq2 ... -threads 3 -out_name $j -out_bad /dev/null/ -out_bad2 /dev/null/ -out_single /dev/null/ -out_single2 /dev/null/

#Trim Galore: removal  of  nextera  adapters  using  Trim  Galore(--stringency  1). 
#STAR: options (-outFilterType BySJout \--outFilterMultimapNmax 20 \--alignSJoverhangMin 8 \--alignSJDBoverhangMin 1 \--outFilterMismatchNmax 999 \--outFilterMismatchNoverLmax 0.04 \--alignIntronMin 20 \--alignIntronMax 1000000 \--alignMatesGapMax  1000000 \--outSAMstrandField  intronMotif  ).  

#aligned reads converted to counts for every gene using HTSeq :(-m  intersection-nonempty \-s no). 

#counts converted to counts per million (CPM) by diving total number of reads and multiplying by 10^6 followed by conversion to log base 10
done


