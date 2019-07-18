library(shiny)
library(plotly)




load("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/Author_gene_count_TSNE/author_gene_count_sc3.RData")
function(input,output){
  output$plot1<-renderPlotly({
    cols<-c()
    for (type in sce$cell_type){
      if (type %in% "oligodenrocytes"){
        cols<-append(cols,input$Oligodenrocytes)
      }else if (type %in% "hybrid"){
        cols<-append(cols,input$Hybrid)
      }else if (type %in% "astrocytes"){
        cols<-append(cols,input$Astrocytes)
      }else if (type %in% "OPC"){
        cols<-append(cols,input$OPC)
      }else if (type %in% "microglia"){
        cols<-append(cols,input$Microglia)
      }else if (type %in% "neurons"){
        cols<-append(cols,input$Neurons)
      }else if (type %in% "endothelial"){
        cols<-append(cols,input$Endothelial)
      }else if (type %in% "fetal_quiescent"){
        cols<-append(cols,input$Fetal_quiescent)
      }else{
        cols<-append(cols,input$Fetal_replicating)
      }
    }
    
    p<-plot_ly(as.data.frame(tsne_plot_10$plot_env$df_to_plot),
               x=~X1,y=~X2,z=~X3, 
               hoverinfo="text", 
               text=paste( sep= "\n", sce$Run, sce$cell_type),
               marker=list(color=cols,size=1),
               type="scatter3d" )
      #layout(scene=scene)
    p
  })
}
