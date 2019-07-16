library(shiny)
library(rgl)

load("./pca_data.RData")
function(input,output){
  output$plot1<-renderRglwidget({
    try(rgl.close())
    plot3d(pca$ind$coord, col = as.character(cols))
    
    par3d(pp)
    rglwidget()
  })
}
