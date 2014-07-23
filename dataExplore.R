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


#clf <- train(trainData, y = yTrain, method="rf")
#clf <- save(clf, file = "clf-rf.RData)
#load("clf-rf.RData") #should load as clf
load("etc.RData")

pred <- predict(etc, testData)

cm <- confusionMatrix(table(pred, yTest))


pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}
#pml_write_files(answers)