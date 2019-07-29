library(shiny)
library(mclust)

load("../clust_workspace.RData")
function(input,output){
  
  output$boxplot<-renderPlot({
    
    data<-get(input$data)
    
    boxplot(data$clust$z, xlab="Cluster", ylab="Clustering Uncertainty")
    par(mfrow=c(1,1))
    })
  
  output$BIC<-renderPlot({
    if (input$data == "auth"){
      n <-8
    }else if (input$data == "orig"){
      n<-10
    }else{
      n<-9
    }
    data<-get(input$data)
    
    plot.mclustBIC(data$clust$BIC,xlab = "Number of components", ylab = "BIC")
    abline(v=n)
  })
}

