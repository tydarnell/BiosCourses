## This vignette is mostly taken from the following reference:
## https://www.analyticsvidhya.com/blog/2016/12/practical-guide-to-implement-machine-learning-with-caret-package-in-r-with-practice-problem/

## 1. install caret
  # install.packages("caret",
  #                  repos = "http://cran.r-project.org", 
  #                  dependencies = c("Depends", "Imports", "Suggests"))
  install.packages(c("caret", "RANN", "e1071", "randomForest", "neuralnet", "gbm"))
  
  library(caret)
  library(tidyverse)
  
## 2. data
  dat.raw <- read.csv("lab10data.csv",stringsAsFactors = T)
  dim(dat.raw)
  sum(complete.cases(dat.raw))
  
## 2.1 imputation (single imputation)
  preProcValues <- preProcess(dat.raw, method = c("knnImpute","center","scale"))
  dat <- predict(preProcValues, dat.raw)
  dim(dat)
  sum(complete.cases(dat))
  # mice::mice() for multiple imputation
  
  
## 3. partitioning data
  set.seed(1)
  index <- createDataPartition(dat$Loan_Status, p=0.75, list=FALSE)
  tr <- dat[index,]
  te <- dat[-index,]

## 4. Feature selection
  set.seed(1)
  RFE <- rfe(x = tr %>% select(-Loan_Status, - Loan_ID), 
             y = tr$Loan_Status, 
             rfeControl = rfeControl(functions = rfFuncs, method = "repeatedcv",
                                     repeats = 3, verbose = FALSE))
  x <- RFE$optVariables[1:5]
  y <- "Loan_Status"
  
## 5. ML tools in caret
  names(getModelInfo())
  # http://topepo.github.io/caret/available-models.html
  
  # Random forest
  set.seed(1)
  model.rf <- train(tr[, x], tr[, y], method = "rf")
    # alternatively
    library(randomForest)
    model.rf2 <- randomForest(tr[, x], tr[, y], data= tr)
  
  # Neural Network
  set.seed(1)
  model.nn <- train(tr[, x], tr[, y], method = "nnet")
    # alternatively
    library(neuralnet)
    model.nn2 <- neuralnet(Loan_Status ~ Credit_History + ApplicantIncome + 
                             CoapplicantIncome + LoanAmount + Loan_Amount_Term, 
                           data= tr) # error
    
    model.nn2 <- neuralnet(as.numeric(Loan_Status) ~ Credit_History + ApplicantIncome + 
                             CoapplicantIncome + LoanAmount + Loan_Amount_Term, 
                           data= tr) # okay
    
    # caret standardizes the syntax of all different ML functions.
  
  # K-Nearest Neighbors
  set.seed(1)
  model.knn <- train(tr[, x], tr[, y], method = "knn")

  
## 6. Customized parameter tuning
  modelLookup(model='rf')
  modelLookup(model='gbm')
  
  # 6.1 tuning using tuneGrid
  grid <- expand.grid(n.trees=c(10, 50, 100, 500),
                      shrinkage=c(0.01, 0.1),
                      n.minobsinnode = c(3, 5),
                      interaction.depth=1)
  
  # We will do 5-fold cross-validation 5 times
  fitControl <- trainControl(
    method = "repeatedcv",
    number = 5,
    repeats = 5)
  
  model.gbm <- train(tr[, x], tr[, y], method = "gbm",
                     trControl = fitControl, tuneGrid = grid)
  model.gbm %>% plot
  
  # 6.2 tuning using tuneLength
  model.gbm2 <- train(tr[, x], tr[, y], method = "gbm",
                     trControl = fitControl, tuneLength = 4)
  model.gbm2 %>% plot
  
## 7. Variable importance
  varImp(object = model.rf)
  varImp(object = model.knn)
  
  plot(varImp(object = model.rf), main="RF - Variable Importance")
  plot(varImp(object = model.knn), main="KNN - Variable Importance")
  
## 8. Prediction
  pred <- predict.train(object = model.rf, te[, x], type = "raw")
  table(pred)
  confusionMatrix(pred, te[, y])
  
  