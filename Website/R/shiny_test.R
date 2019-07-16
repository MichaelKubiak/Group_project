#shiny app
library(shiny)

pcaplot<-plot3d(pca$ind$coord, col = as.character(cols))
ui<-shinyUI(
  basicPage(
    rglwidgetOutput("plot1"),
    verbatimTextOutput("Hi")
  )
)

server <- function(input,output){
  output$plot1<-renderRglwidget({
    try(rgl.close())
    plot3d(pca$ind$coord, col = as.character(cols))
    rglwidget()
  })
}
runApp(list(ui=ui, server=server))
