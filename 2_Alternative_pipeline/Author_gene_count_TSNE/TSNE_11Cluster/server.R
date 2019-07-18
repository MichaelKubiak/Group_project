library(shiny)
library(plotly)




load("../author_gene_count_sc3.RData")
function(input,output){
  output$plot1<-renderPlotly({
    cols<-c()
    for (type in sce$sc3_11_clusters){
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
      }else if (type %in% "6"){
        cols<-append(cols,input$Cluster_6)
      }else if (type %in% "7"){
        cols<-append(cols,input$Cluster_7)
      }else if (type %in% "8"){
        cols<-append(cols,input$Cluster_8)
      }else if (type %in% "9"){
        cols<-append(cols,input$Cluster_9)
      }else if (type %in% "10"){
        cols<-append(cols,input$Cluster_10)
      }else{
        cols<-append(cols,input$Cluster_11)
      }
    }
    
    p<-plot_ly(as.data.frame(tsne_plot_10$plot_env$df_to_plot),
               x=~X1,y=~X2,z=~X3, 
               hoverinfo="text", 
               text=paste( sep= "\n", sce$Run, sce$sc3_11_clusters),
               marker=list(color=cols,size=1),
               type="scatter3d" )
      #layout(scene=scene)
    p
  })
}
