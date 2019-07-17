library(shiny)
library(plotly)

load("./pca_data.RData")



function(input,output){
  output$plot1<-renderPlotly({
    cols<-c()
    for (type in types){
      if (type %in% "adult neuron"){
        cols<-append(cols,input$colad)
      }else if (type %in% "foetal quiescent neuron"){
        cols<-append(cols,input$colfq)
      }else{
        cols<-append(cols,input$colfr)
      }
    }
    
    p<-plot_ly(as.data.frame(pca$ind$coord),x=~Dim.1,y=~Dim.2,z=~Dim.3, hoverinfo="text", text=types,marker=list(color=cols,size=1), type="scatter3d") %>%
      layout(scene=scene)
    p
  })
}
