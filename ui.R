

library(shiny)
# Loading packages I need
library(ggvis)
library(rmarkdown)
library(dplyr)
library(caret)
library(randomForest)
library(e1071)
library(klaR)
library(kernlab)
library(MASS)

shinyUI(
  navbarPage("Comparing the 'ML' algorithms through the 'iris' Data", 
             tabPanel("Run Machine Learning", 
                      sidebarPanel(
                        selectInput("models",
                                    "Choose the ML model:",
                                    choices = c("Random Forest" = "rf", 
                                                "Naive Bayes" = "nb", 
                                                "SVM" = "svmRadial", 
                                                "LDA" = "lda", 
                                                "CART" = "rpart",
                                                "K-Nearest Neighbors" = "knn", 
                                                "Neural Network" = "nnet")),
                        
                        sliderInput("prob", label = "Portion(%) of the Training set: ", 
                                    min = 10, 
                                    max = 100, 
                                    value = 50),
                        
                        numericInput("seeds", label = "Seed for the Random Number: ", 
                                     value = 444, min = 1, max = 10000, step = 1),
                        
                        div(
                          actionButton(inputId = "run", 
                                       label = "Run the Machine Learning"), 
                          style = "text-align: center;")
                      ),
                      
                      # Show the plot of the generated distribution
                      mainPanel(
                        div(
                          h3("The Scatter Plot of the iris Data"),
                          style = "text-align: center;"), 
                        
                        div(style = "color:red", 
                            h5(textOutput("plot.title"), align = "center")
                        ),
                        
                        div(align = "center", 
                            ggvisOutput("resultPlot"), 
                            uiOutput("resultPlot_ui")
                        ), 
                        
                        div(
                          h3(textOutput("comp.title"), align = "center"), 
                          h5(textOutput("comp.explain"), align = "center"), 
                          style = "text-align: center;"),
                        div(align = "center", 
                            tableOutput("comp.matrix")
                        ),
                        
                        div(
                          h3(textOutput("conf.title"), align = "center"), 
                          h5(textOutput("conf.explain"), align = "center"), 
                          style = "text-align: center;"),
                        
                        div(align = "center", 
                            tableOutput("conf.matrix")
                        )
                      )
             
             
        
             )
  )
)