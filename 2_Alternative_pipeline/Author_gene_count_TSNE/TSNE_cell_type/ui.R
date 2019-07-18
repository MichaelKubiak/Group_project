library(shiny)
library(plotly)
library(colourpicker)

#install.packages("colourpicker")

load("/home/tsc21/Documents/BS7120/Group_project/2_Alternative_pipeline/scPipe/Test/expression_data.RData")
fluidPage(
  titlePanel("tSNE plot using the author generated gene counting matrix and information table"),
  sidebarLayout(
    sidebarPanel(
      colourInput("Oligodenrocytes",  "Oligodenrocytes",  value="#000080"),
      colourInput("Hybrid",           "Hybrid",           value="#FF0000"),
      colourInput("Astrocytes",       "Astrocytes",       value="#FFA500"),
      colourInput("OPC",              "OPC",              value="#008000"),
      colourInput("Microglia",        "Microglia",        value="#964B00"),
      colourInput("Neurons",          "Neurons",          value="#9966CC"),
      colourInput("Endothelial",      "Endothelial",      value="#00FFFF"),
      colourInput("Fetal_quiescent",  "Fetal_quiescent",  value="#FD6C9E"),
      colourInput("Fetal_replicating","Fetal_replicating",value="#808080")
      ),
    mainPanel(
      plotlyOutput("plot1"),
      verbatimTextOutput("Hi")
    )
  )

)