library(shiny)
library(plotly)
library(igraph)

load("./foetal_cells_spanning_workspace.RData")

function(input,output){
  output$plot1<-renderPlot({
    data<-get(input$data)
    print(data$com)
    E(data$min.span.tree)$color<-"gray"
    if (input$path){
      E(data$min.span.tree, path=unlist(data$long.edges$vpath))$color<-"red"
    }
    V(data$min.span.tree)$color<-c(input$C1, input$C2, input$C3, input$C4, input$C5, input$C6, input$C7, input$C8, input$C9, input$C10,input$C11,input$C12,input$C13)[membership(data$com)]
    plot (data$min.span.tree,vertex.size=3, vertex.label=NA)
  })
}
