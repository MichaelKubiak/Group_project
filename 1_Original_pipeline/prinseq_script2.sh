raw_data="/home/rsk17/Group_project/1_Original_pipeline/scpipe_testing/"
#loops through files within the named directory
for i in /home/rsk17/Group_project/1_Original_pipeline/scpipe_testing/* #could just write raw_data/*
do
#two run through both files within a folder
#pair read suffixes
	one="_1.fastq.gz"
	two="_2.fastq.gz"
	#echo this $i
	j=${i#$raw_data}
	one=$i"/"$j$one
	two=$i"/"$j$two
	#echo "file $one"
	#echo "file $two"
#	prinseq++ -min_len 30 -trim_left 10 -trim_qual_right 25 -lc_entropy 0.65-fastq $one -fastq2 $two -threads 3 -out_name $j -out_bad /dev/null/ -out_bad2 /dev/null/ -out_single /dev/null/ -out_single2 /dev/null/

#having no output file specified means that a default output file is used and is overridden everytime STAR is ran 
/home/rsk17/Group_project/1_Original_pipeline/STAR --readFilesIn $one $two --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax  1000000 --outSAMstrandField  intronMotif --runThreadN 4 --genomeDir HG19 --readFilesCommand zcat



	htseq-count -m intersection-nonempty -s no Aligned.out.sam UCSC_geneid.gtf > $j"output_sam.counts.csv"
#alter names of output to end in .csv and put all in a new folder
python3 data_combination.py $j"output_sam.counts.csv" /home/rsk17/Group_project/1_Original_pipeline_/expression_matrix/
done
