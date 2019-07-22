library(shiny)
library(plotly)
library(colourpicker)

#install.packages("colourpicker")

load("../author_gene_count_sc3.RData")
fluidPage(
  titlePanel("tSNE plot for 8 clusters using the author generated gene counting matrix"),
  sidebarLayout(
    sidebarPanel(
      colourInput("Cluster_1",   "Cluster_1",   value="#000080"),
      colourInput("Cluster_2",   "Cluster_2",   value="#FF0000"),
      colourInput("Cluster_3",   "Cluster_3",   value="#FFA500"),
      colourInput("Cluster_4",   "Cluster_4",   value="#008000"),
      colourInput("Cluster_5",   "Cluster_5",   value="#964B00"),
      colourInput("Cluster_6",   "Cluster_6",   value="#9966CC"),
      colourInput("Cluster_7",   "Cluster_7",   value="#00FFFF"),
      colourInput("Cluster_8",   "Cluster_8",   value="#FD6C9E")
      ),
    mainPanel(
      plotlyOutput("plot1"),
      verbatimTextOutput("Hi")
    )
  )

)