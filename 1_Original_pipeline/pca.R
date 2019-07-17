library(argparse)
library(FactoMineR)
library(rgl)

parser<-ArgumentParser(description="performs analysis through the pipeline outlined in Darmanis et al")
parser$add_argument("adult_neurons", help="The adult neurons")
parser$add_argument("foetal_q", help="The foetal quiescent cells")
parser$add_argument("foetal_r", help="The foetal replicating cells")
parser$add_argument("--cores", "-r", default=4, help="the number of cores to use")

args<-parser$parse_args()

ad<-as.data.frame(read.delim("neurons",row.names=1,header=TRUE))
fq<-as.data.frame(read.delim("foetal_cells_quiescent", row.names=1,header=TRUE))
fr<-as.data.frame(read.delim("foetal_cells_replicating",row.names=1,header=TRUE))

mergeneurons<-function(x,y){
  full<-merge(x,y,by=0,all=TRUE)
  row.names(full)<-full$Row.names
  full$Row.names<-NULL
  return (full)
}

full<-Reduce(mergeneurons, list(ad,fq,fr))
write.table(full,"all_neurons",sep="\t")
system(paste0("Rscript ./scde_analysis.R all_neurons -p -r ", args$cores))

dist.mat<-read.delim("distance_matrix_for_pca",row.names=1,header=TRUE,sep="\t")
cols <-list()
for (i in 1:length(colnames(dist.mat))){
  if (colnames(dist.mat)[[i]] %in% colnames(ad)){
    
    cols<-append(cols, "blue")
  }
  else if(colnames(dist.mat)[[i]] %in% colnames(fq)){
    cols<-append(cols,"red")
  }else{
    cols<-append(cols,"orange")
  }
}
pca<-PCA(t(dist.mat))
plot3d(pca$ind$coord, col = as.character(cols))
write.csv(pca)