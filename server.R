library(shiny)

shinyServer(function(input, output) {
  data(iris)
  result_iris <- iris 
  result_iris$Predicted <- iris$Species
  models <- data.frame(comm = c("rf", "nb", "svmRadial", "lda", "rpart", "knn", "nnet"), 
                       model.name = c("Random Forest", 
                                      "Naive Bayes", 
                                      "SVM", 
                                      "LDA", 
                                      "CART", 
                                      "K-Nearest Neighbors", 
                                      "Neural Network"))
  
  observeEvent(input$run, {
    index <- createDataPartition(iris$Species, list = F, p = input$prob / 100)
    # I don't need to make the test dataset
    # Because I just have to adjust my model into whole iris dataset
    set.seed(input$seeds)
    fit <- train(Species ~ ., method = input$models, data = iris[index, ])
    result_iris$Predicted <- predict(fit, newdata = iris[, -5])
    result_iris$result <- c(result_iris$Species == result_iris$Predicted)
    result_iris$result[result_iris$result == T] <- "Right"
    result_iris$result[result_iris$result == F] <- "Error"
    m.name <- models$model.name[models$comm == input$models]        
    output$plot.title <- renderText(paste("Predicted using the", m.name))
    output$comp.title <- renderText("The Comparison Table")
    output$comp.explain <- renderText(
      "The horizontal axis is the Predicted value, and The vertical axis is the Original value.")
    output$comp.matrix <- renderTable({
      with(result_iris, confusionMatrix(Predicted, Species)$table)
    })
    
    output$conf.title <- renderText("The Confusion Matrix")
    output$conf.explain <- renderText(
      "You can know in the 'About' page what each object is.")
    output$conf.matrix <- renderTable({
      with(result_iris, t(confusionMatrix(Species, Predicted)$byClass))
    })
    
    result_iris %>% 
      ggvis(~Sepal.Length, ~Petal.Length, 
            fill = ~Predicted, opacity := 0.3, 
            shape = ~result, 
            size := 150) %>% 
      layer_points() %>% 
      add_legend("fill", title = "Type of the iris") %>% 
      add_legend("shape", orient = "left", title = "Predictions") %>% 
      bind_shiny("resultPlot", "resultPlot_ui")
  })
  
  reactive ({
    result_iris %>% 
      ggvis(~Sepal.Length, ~Petal.Length, 
            fill = ~Predicted, opacity := 0.3, 
            size := 150) %>% 
      layer_points() %>% 
      add_legend("fill", orient = "right", title = "Type of the iris")
  }) %>% bind_shiny("resultPlot", "resultPlot_ui")
})

