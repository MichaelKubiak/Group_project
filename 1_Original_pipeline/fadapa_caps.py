from fadapa import Fadapa
import sys

file_one = sys.argv[1]

#f = Fadapa('/home/rsk17/Group_project/1_Original_pipeline/SRR1974725_1_fastqc/fastqc_data.txt')
#f2 = Fadapa('/home/rsk17/Group_project/1_Original_pipeline/SRR1974725_2_fastqc/fastqc_data.txt')
f = Fadapa('/home/rsk17/Group_project/1_Original_pipeline/'+file_one+'/fastqc_data.txt')

good_seq = f.raw_data("Overrepresented sequences")[0]
#good_seq2 = f2.raw_data("Overrepresented sequences")[0]
seq_list = []
#seq_list2 = [] 

#if good_seq is pass in this case use ==
if good_seq != ">>Overrepresented sequences	pass":
	for data in f.clean_data('Overrepresented sequences'):
		seq_list.append(data[0])


#this gets the output into the correct format for cutadapt (-a XXXX etc)
output = ""
for items in seq_list[1:]:
	output = output + "-A" + items
#+ ">" + file_one + "\n" + "-a " + items + "\n"
print(output)
