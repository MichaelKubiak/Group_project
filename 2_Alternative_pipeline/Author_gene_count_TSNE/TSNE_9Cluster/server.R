library(shiny)
library(plotly)




load("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/scPipe/Test/expression_data.RData")
function(input,output){
  output$plot1<-renderPlotly({
    cols<-c()
    for (type in sce$sc3_9_clusters){
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
      }else{
        cols<-append(cols,input$Cluster_9)
      }
    }
    
    p<-plot_ly(as.data.frame(tsne_plot_10$plot_env$df_to_plot),
               x=~X1,y=~X2,z=~X3, 
               hoverinfo="text", 
               text=paste( sep= "\n", sce$Run, sce$sc3_9_clusters),
               marker=list(color=cols,size=1),
               type="scatter3d" )
      #layout(scene=scene)
    p
  })
}
