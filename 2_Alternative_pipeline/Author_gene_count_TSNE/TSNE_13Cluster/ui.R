library(shiny)
library(plotly)
library(colourpicker)

#install.packages("colourpicker")

load("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/Author_gene_count_TSNE/author_gene_count_sc3.RData")
fluidPage(
  titlePanel("tSNE plot for 13 clusters using the author generated gene counting matrix"),
  sidebarLayout(
    sidebarPanel(
      colourInput("Cluster_1",   "Cluster_1",   value="#000080"),
      colourInput("Cluster_2",   "Cluster_2",   value="#FF0000"),
      colourInput("Cluster_3",   "Cluster_3",   value="#FFA500"),
      colourInput("Cluster_4",   "Cluster_4",   value="#008000"),
      colourInput("Cluster_5",   "Cluster_5",   value="#964B00"),
      colourInput("Cluster_6",   "Cluster_6",   value="#9966CC"),
      colourInput("Cluster_7",   "Cluster_7",   value="#00FFFF"),
      colourInput("Cluster_8",   "Cluster_8",   value="#FD6C9E"),
      colourInput("Cluster_9",   "Cluster_9",   value="#808080"),
      colourInput("Cluster_10",  "Cluster_10",  value="#FF00FF"),
      colourInput("Cluster_11",  "Cluster_11",  value="#FFD700"),
      colourInput("Cluster_12",  "Cluster_12",  value="#3FFF00"),
      colourInput("Cluster_13",  "Cluster_13",  value="#00FF7F")
      ),
    mainPanel(
      plotlyOutput("plot1"),
      verbatimTextOutput("Hi")
    )
  )

)