from fadapa import Fadapa
import sys

file_one = sys.argv[1]

f = Fadapa('/home/rsk17/Group_project/1_Original_pipeline/'+file_one+'/fastqc_data.txt')
#look for certain phrases ie Overrepresented sequences 
good_seq = f.raw_data("Overrepresented sequences")[0]
#create an empty list fo the overrepresented sequences to be appended to 
seq_list = []


#if good_seq is pass in this case use ==
#if there is no overrepresented sequences pass then the loop continues, otherwise the loop is broken
if good_seq != ">>Overrepresented sequences	pass":
	for data in f.clean_data('Overrepresented sequences'):
#the overrepresented sequences found are appended to the seq_list previously created
		seq_list.append(data[0])


#this gets the output into the correct format for cutadapt (-a XXXX etc)
#creates output and uses the seq_list from before to output the found sequences into a format that can be used by cutadapt.
output = ""
#seq_list[1:] means that everything that isnt seq_list[0] (#sequence)
for items in seq_list[1:]:
	output = output + "-a" + items

