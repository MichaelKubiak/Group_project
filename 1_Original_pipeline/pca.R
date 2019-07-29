# ---------------------------------------------------------------------------------------------------
# A script to combine 3 files containing data about different groups of neurons, then use scde_analysis.R 
# to produce a distance matrix that it can use to perform pca.
# ---------------------------------------------------------------------------------------------------

library(argparse)
library(FactoMineR)
library(rgl)

#Argparse arguments to take file names of input files and the number of cores to run the script with
parser<-ArgumentParser(description="performs analysis through the pipeline outlined in Darmanis et al")
parser$add_argument("adult_neurons", help="The adult neurons")
parser$add_argument("foetal_q", help="The foetal quiescent cells")
parser$add_argument("foetal_r", help="The foetal replicating cells")
parser$add_argument("--cores", "-r", default=4, help="the number of cores to use")

args<-parser$parse_args()

# read in files as data frames
ad<-as.data.frame(read.delim(args$adult_neurons,row.names=1,header=TRUE))
fq<-as.data.frame(read.delim(args$foetal_q, row.names=1,header=TRUE))
fr<-as.data.frame(read.delim(args$foetal_r,row.names=1,header=TRUE))

# function to merge the data frames into one
mergeneurons<-function(x,y){
  full<-merge(x,y,by=0,all=TRUE)
  # move row names back into the correct place, and remove that column from the dataframe
  row.names(full)<-full$Row.names
  full$Row.names<-NULL
  return (full)
}

# perform the merge
full<-Reduce(mergeneurons, list(ad,fq,fr))

# write out the full set so that it can be used in the scde_analysis script
write.table(full,"all_neurons",sep="\t")

# run the scde direct dropout to provide a distance matrix
system(paste0("Rscript ./scde_analysis.R all_neurons -p -r ", args$cores))

# read the produced distance matrix in
dist.mat<-read.delim("distance_matrix_for_pca",row.names=1,header=TRUE,sep="\t")

# produce a list of which cells are from which group so that they can be coloured
types <-list()
for (i in 1:length(colnames(dist.mat))){
  if (colnames(dist.mat)[[i]] %in% colnames(ad)){
    
    types<-append(types, "adult neuron")
  }
  else if(colnames(dist.mat)[[i]] %in% colnames(fq)){
    types<-append(types,"foetal quiescent neuron")
  }else{
    types<-append(types,"foetal replicating neuron")
  }
}
# perform a principle component analysis
pca<-PCA(dist.mat)
# produce a workspace image so that further analysis and graph plotting can be performed
save.image("pca.RData")
