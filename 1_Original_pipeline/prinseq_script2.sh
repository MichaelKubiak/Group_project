#mrna processing section for original pipeline
raw_data=/home/rsk17/Group_project/1_Original_pipeline/RAW_data/
#loops through files within the named directory and files 
for i in /home/rsk17/Group_project/1_Original_pipeline/RAW_data/*
do
#two run through both files within a folder
#pair read suffixes
	one="_1.fastq.gz"
	two="_2.fastq.gz"
	#echo this $i
	j=${i#$raw_data}
	one=$i"/"$j$one
	two=$i"/"$j$two
#how to install STAR
#'''wget https://github.com/alexdobin/STAR/archive/2.7.1a.tar.gz
#tar -xzf 2.7.1a.tar.gz
#cd STAR-2.7.1a'''
#to use star a genome index needs to be generated using spectre due to not enough RAM space on the laptops
#/home/r/rsk17/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 6 --runMode genomeGenerate --genomeDir ~/HG19 --genomeFastaFiles ~/hg19/hg19.fa --sjdbGTFfile ~/hg19/hg.GTF --sjdbOverhang 74 --genomeSAsparseD 4

#to make a GTF file. used https://genome.ucsc.edu/cgi-bin/hgTables table browser and change the assembly type to GRCh37/hg19 and output format to GTF
#the gene names within the file need altering as ucsc table browser HTF files have the wrong output names.
#awk 'NR==FNR{A[$1]=$2;next} $2 in A{$2=A[$2]}1' FS=, conversion.csv FS=\" OFS=\" UCSC.gtf > UCSC_geneid.gtf

#having no output file specified means that a default output file is used and is overridden everytime STAR is ran 
#parameters: -readFilesIn= the files containing the sequences to be mapped in fastq format, -outFilterType= BySJout - keeps only the reads that contain junctions that passed fitering to SJ.out.tab, -outFilterMultimapNmax = read alignments will be output only if the read maps fewer than this value,otherwise no alignments will be output (default 10), -alignSJoverhangMin(default 8)= minimum overhang for unannotated junctions, -alignSJDBoverhangMin(default 1)= minimum overhang for annotated junctions, -outFilterMismatchNmax(default 999)= maximum number of mismatches per pair, large number switches off this filter, -outFilterMismatchNoverLmax(default 0.04)= max number of mismatches per pair relative to read length:  for 2x100b, max number of mis-matches is 0.06*200=8 for the paired read, -alignIntronMin(default 20)= minimum intron length, -alignIntronMax(default 1000000)= maximum intron length, -alignMatesGapMax(default 1000000)= maximum genomic distance between mates, -outSAMstrandField intronMotif = unstranded RNA-seq data, -runThread(default 1)= number of threads to run STAR, -genomeDir(default ./GenomeDir/)= path to the directory where genome files are stored (ifrunMode!=generateGenome) or will be generated (ifrunMode==generateGenome), -readFilesCommand( default -)= command line to execute for each of the input file.  This commandshould generate FASTA or FASTQ text and send it to stdout.
/home/rsk17/Group_project/1_Original_pipeline/STAR --readFilesIn $one $two --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax  1000000 --outSAMstrandField  intronMotif --runThreadN 8 --genomeDir HG19 --readFilesCommand zcat

#install htseq through pip:pip install HTSeq
#-m is the mode to handle reads that are overlapping more than one feature (use intersection-nonempty), -s no = a read considered overlapping with a feature regardless of whether it is mapped to same or opposite strange as the feature. -s yes would indicate a read having to be mapped to same strand as the feature. -f same indicates the format of the input data. sam is the default so does not need to be stated but will not , > indicates the file to put the output information into.
htseq-count -m intersection-nonempty -s no Aligned.out.sam UCSC_geneid.gtf > $j"output_sam.counts.csv"
#call data_combination.py script and specify the location of the input files and the location where the output should be located, it combines csv files within the input location
python3 data_combination.py /home/rsk17/Group_project/1_Original_pipeline /home/rsk17/Group_project/1_Original_pipeline/expression_matrix/combined_datas

#in librecalc do:=SUM(B2:B28517)
#use data from other sheets of the csv calc document https://ask.libreoffice.org/en/question/11496/calc-how-to-properly-reference-cells-from-other-sheet/
#=IF(((combined_data.B2/combined_data.B$28526)*10000000)=0, 0, LOG10((combined_data_1.B2/combined_data_1.B$28526)*10000000))
done
