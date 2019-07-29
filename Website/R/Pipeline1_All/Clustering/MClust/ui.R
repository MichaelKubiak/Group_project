library(shiny)
library(colourpicker)

#Load data within the 'RData' file that are required to create the graph
load("../clust_workspace.RData")
fluidPage(
  titlePanel("Graphs produced by MClust providing clustering and uncertainty of clusters"),
  fluidRow(
    column(4,
                  selectInput("data", "Dataset", c("Author Generated Count Matrix"="auth", 
                                                   "Original Pipeline Reproduced Count Matrix"="orig", 
                                                   "New Pipeline Count Matrix"="sec"))
    )
    
  ),
  fluidRow(
    column(12, plotOutput("BIC"))
  ),
  fluidRow(
    column(12, plotOutput("boxplot"))
  )
)
