library(shiny)
library(rgl)

load("./pca_data.RData")
basicPage(
  rglwidgetOutput("plot1"),
  verbatimTextOutput("Hi")
)