library(caret)
library(kernlab)
set.seed(42)

harData <- read.csv("Data/pml-training.csv")

inTrain <- createDataPartition(y=harData$classe, p=0.75, list=FALSE)

trainData <- harData[inTrain,]
testData <- harData[-inTrain,]

cvData <- read.csv("Data/pml-testing.csv")

dcols <- names(cvData)[grepl("^gyros|^roll|^pitch|^yaw|^accel", names(cvData))]

yTrain <- trainData[,"classe"]
yTest <- testData[,"classe"]


trainData <- trainData[,dcols]
testData <- testData[,dcols]
cvData <- cvData[,dcols]

clf <- train(trainData, y = yTrain, method="rf")