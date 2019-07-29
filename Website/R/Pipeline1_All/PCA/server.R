library(shiny)
library(plotly)

load("./pca_data.RData")



function(input,output){
  
  output$plot1<-renderPlotly({
    
    data<-get(input$data)
    cols<-c()
    for (type in data$types){
      if (type %in% "adult neuron"){
        cols<-append(cols,input$colad)
      }else if (type %in% "foetal quiescent neuron"){
        cols<-append(cols,input$colfq)
      }else{
        cols<-append(cols,input$colfr)
      }
    }
    data$pca$ind$coord<-as.data.frame(data$pca$ind$coord)
    data$pca$ind$coord$cols<-cols
    plot_ly(marker=list(size=1))%>%
      add_markers(x=data$pca$ind$coord$Dim.1[data$pca$ind$coord$cols==input$colad],y=data$pca$ind$coord$Dim.2[data$pca$ind$coord$cols==input$colad],z=data$pca$ind$coord$Dim.3[data$pca$ind$coord$cols==input$colad], name="Adult")%>%
      add_markers(x=data$pca$ind$coord$Dim.1[data$pca$ind$coord$cols==input$colfq],y=data$pca$ind$coord$Dim.2[data$pca$ind$coord$cols==input$colfq],z=data$pca$ind$coord$Dim.3[data$pca$ind$coord$cols==input$colfq], name="Foetal Quiescent")%>%
      add_markers(x=data$pca$ind$coord$Dim.1[data$pca$ind$coord$cols==input$colfr],y=data$pca$ind$coord$Dim.2[data$pca$ind$coord$cols==input$colfr],z=data$pca$ind$coord$Dim.3[data$pca$ind$coord$cols==input$colfr], name="Foetal Replicating")  
    })
}
