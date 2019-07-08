library(argparse)
library(parallel)
library(scde)
library(tsne)
library(mclust)
library(igraph)
library(FactoMineR)

parser<-ArgumentParser(description="performs analysis through the pipeline outlined in Darmanis et al")
parser$add_argument("Input",help="The file to be read")
parser$add_argument("--clustering", "-c", action="store_true", help="perform the clustering section")
parser$add_argument("--spanning", "-s", action="store_true", help="perform the spanning tree section")
parser$add_argument("--pca","-p", action="store_true", help="perform the pca section")

arguments<-parser$parse_args()

# read in expression count matrix
counts<-read.delim(arguments$Input,sep="\t",header = TRUE, row.names=1)

# filter the count matrix, removing cells with fewer than 1800 genes, genes with fewer than 1 read, and genes that are not detected in any cells
counts <- clean.counts(counts, min.reads = 1,min.detected = 1)
# build error models 
models <- scde.error.models(counts, n.cores=4,threshold.segmentation = TRUE, save.crossfit.plots = FALSE, save.model.plots = FALSE)

# keep only valid cells (where their correlation is positive) in the models
valid.cells<-models$corr.a > 0
models <- models[valid.cells,]
# calculate the prior distribution of genes
prior <- scde.expression.prior(models, counts)
# estimate the drop-out probability for each cell
p.self.fail <- scde.failure.probability(models, counts = counts)
# perform simulations to determine the most likely expression distances between cells
# set variables
n.simulations <- 1000 
k<-0.9
cell.names <- colnames(counts)
names(cell.names) <- cell.names

# define the direct dropout simulation function
simulate <- function(i){
  scd1 <- do.call(cbind,lapply(cell.names,function(nam){
    x <- counts[,nam];
    x[!as.logical(rbinom(length(x),1,1-p.self.fail[,nam]*k))] <- NA;
    x;
  }))
  rownames(scd1) <- rownames(counts)
  cor(log10(scd1+1),use="pairwise.complete.obs")
  
}
# perform the direct dropout simulations using 4 cores
dl<-mclapply(1:n.simulations,simulate, mc.cores = 4)
write.table(dl, file=paste("dl",arguments$Input,sep="_"),sep="\t")
# produce an expression distance matrix for the cells
direct.dist.mat <- 1-Reduce("+",dl)/length(dl)
# turn that matrix into a dist object for use by tsne
direct.dist <- as.dist(direct.dist.mat)
#clustering section
if (arguments$clustering){
  # dimensionally reduce the expression distance matrix to 3 dimensions using tsne
  dim.red.dist <- tsne(direct.dist, k=3)
  # output the reduced matrix to file so that it can be used for the website
  write.table(dim.red.dist,file=paste("distance",arguments$Input,sep="_"),sep="\t")
  # output a 3d tsne plot to file
  svg(filename=paste("tsne_plot",arguments$Input,".svg",sep="_"),
      width = 20,
      height = 20,
      pointsize = 10
  )
  plot3d (dim.red.dist)
  dev.off()
  
  # perform clustering on the dimensionally reduced data
  clust <- Mclust(dim.red.dist,G=1:40, modelNames = c("EII","VVI","VII","EEE","EEI","EEV","VEI","VEV","EVI","VVV"), prior = priorControl())
  #output Mclust object to file
  tryCatch({
    write.csv(clust, file=paste("clustering",arguments$Input,sep="_"), row.names=FALSE)
  }, error = function(cond){
    print(cond)
  }, warning = function(cond){
    print(cond)
  })
  # output a Baysian Information Criterion graph that can be used to determine how many clusters are present
  svg(filename=paste("BIC",arguments$Input,".svg",sep="_"),
      width=20,
      height=20,
      pointsize=10)
  plot(clust,what="BIC")
  dev.off()
  
  # output a boxplot of the error on the clustering
  svg(filename=paste("Boxplot",arguments$Input,".svg",sep="_"),
      width =20,
      height=20,
      pointsize=10)
  plot(clust$z)
  dev.off()
}
if (arguments$spanning){
  #produce a minimum spanning tree based on the weighted adjacency matrix (distance matrix)
  dist.graph<- graph.adjacency(as.matrix(direct.dist.mat),weighted=T)
  min.span.tree<-mst(dist.graph)
  #colour vertices by membership
  com<-cluster_walktrap(min.span.tree)
  V(min.span.tree)$color<-com$membership+1
  #get longest path
  long<-which(direct.dist.mat==max(direct.dist.mat),arr.ind=TRUE)
  long.edges<-shortest_paths(min.span.tree, from=116, to=125)
  #colour edges on the path
  E(min.span.tree)$color<-"gray"
  E(min.span.tree, path=unlist(long.edges$vpath))$color<-"red"
  #output spanning tree to file
  tryCatch({
    write.graph(min.span.tree,file=paste("spantree",arguments$Input,sep="_"))
  }, error = function(cond){
    print(cond)
  }, warning = function(cond){
    print(cond)
  })
  # produce an image of the tree
  svg(filename=paste("min_span",arguments$Input,".svg",sep="_"),
      width=20,
      height=20,
      pointsize=10)
  plot (min.span.tree,vertex.size=1)
  dev.off()
}
if(arguments$pca){
  #TODO: perform pca
}