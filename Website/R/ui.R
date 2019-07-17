library(shiny)
library(plotly)
library(colourpicker)

load("./pca_data.RData")
fluidPage(
  titlePanel("PCA plot")
  sidebarLayout(
    sidebarPanel(
      colourInput()
    )
  )
  mainPanel(
    plotlyOutput("plot1"),
    verbatimTextOutput("Hi")
  )
)