from fadapa import Fadapa
import sys

file_one = sys.argv[1]
#file_two = sys.argv[2]
print(sys.argv[1])
#print(sys.argv[2])
#f = Fadapa('/home/rsk17/Group_project/1_Original_pipeline/SRR1974725_1_fastqc/fastqc_data.txt')
#f2 = Fadapa('/home/rsk17/Group_project/1_Original_pipeline/SRR1974725_2_fastqc/fastqc_data.txt')
f = Fadapa('/home/rsk17/Group_project/1_Original_pipeline/'+file_one+'/fastqc_data.txt')
#f = Fadapa('/home/rsk17/Group_project/1_Original_pipeline/'+file_two+'/fastqc_data.txt')
#+file_one+'_fastqc/fastqc_data.txt')
#print(f.raw_data('Overrepresented sequences'))
#print(f.clean_data('Overrepresented sequences'))
list =  f.clean_data('Overrepresented sequences')
#list2 =  f2.clean_data('Overrepresented sequences')
#print(list[1])
#n=len(list)-1
#print(n)
#del list[n]
#del list[0]
#print(list)
good_seq = f.raw_data("Overrepresented sequences")[0]
#good_seq2 = f2.raw_data("Overrepresented sequences")[0]
seq_list = []
#seq_list2 = [] 

#if good_seq is pass in this case use ==
if good_seq != ">>Overrepresented sequences	pass":
	for data in f.clean_data('Overrepresented sequences'):
		#for data1 in f2.clean_data('Overrepresented sequences'):
    #print(data[0: ])
		print(data[0])
		#	print(data2[0])
		seq_list.append(data[0])
		#seq_list2.append(data2[0])
#print(seq_list)
#this gets the output into the correct format for cutadapt (-a XXXX etc)
output = ""
#output2 = ""
#writes a list of results to a file called overrep_seq.txt
file = open("overrep_seq.txt","w")
for items in seq_list[1:]:
	output = output + "-a " + items
#print(output)
file.write(output)
file.close()
#file = open("overrep_seq2.txt", "w")
#for items in seq_list2[1:]:
#	output2 = output2 + "-a" + items
#file.write(output2)
#file.close()
#print(output)

