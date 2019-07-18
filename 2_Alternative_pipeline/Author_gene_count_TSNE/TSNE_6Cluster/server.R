library(shiny)
library(plotly)




load("../author_gene_count_sc3.RData")
function(input,output){
  output$plot1<-renderPlotly({
    cols<-c()
    for (type in sce$sc3_6_clusters){
      if (type %in% "1"){
        cols<-append(cols,input$Cluster_1)
      }else if (type %in% "2"){
        cols<-append(cols,input$Cluster_2)
      }else if (type %in% "3"){
        cols<-append(cols,input$Cluster_3)
      }else if (type %in% "4"){
        cols<-append(cols,input$Cluster_4)
      }else if (type %in% "5"){
        cols<-append(cols,input$Cluster_5)
      }else{
        cols<-append(cols,input$Cluster_6)
      }
    }
    
    p<-plot_ly(as.data.frame(tsne_plot_10$plot_env$df_to_plot),
               x=~X1,y=~X2,z=~X3, 
               hoverinfo="text", 
               text=paste( sep= "\n", sce$Run, sce$sc3_6_clusters),
               marker=list(color=cols,size=1),
               type="scatter3d" )
      #layout(scene=scene)
    p
  })
}
