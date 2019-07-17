library(shiny)
library(rgl)

load("./pca_data.RData")
function(input,output){
  plot1<-renderRglwidget({
    try(rgl.close())
    plot3d(pca$ind$coord, col = as.character(cols), axes=FALSE, xlab="", ylab="",zlab="")
    par3d(userMatrix=us.mat.start)
    legend3d("topright",legend= c("Foetal Quiescent", "Foetal Replicating", "Adult Neurons"),pch=16, col=c("red","orange","blue"), cex=.5)
    axes3d(edges="bbox", xlab="Dim1",ylab="Dim2",zlab="Dim3",extend=1.5)
    rglwidget()
  })
}
