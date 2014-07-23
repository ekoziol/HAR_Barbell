# Predicting Quality of Weight Lifting from Activity Monitoring Sensors
## Eric Koziol

### Summary
This investigation attempts to predict the if a subject is performing a dumbell exercise correctly or incorrectly.  Incorrect performance of the exercise was broken down into a total of four different types, for a total of five categorical classification classes.  Using a random forest model, the author was able to obtain a prediction accuracy of 99.6%.

### Goal
The goal of this prediction investigation is to predict how well a subject is performing a barbell exercise.  The categories of correctness of exercise are broken down as follows:

"Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E)."

The training data for this project are available here: 

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here: 

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

The data has been obtained from http://groupware.les.inf.puc-rio.br/har (see Weight Lifting Exercise Dataset) which is provided by Wallace Ugulino, Eduardo Velloso and Hugo Fuks.  Please also see their paper:

Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.

Read more: http://groupware.les.inf.puc-rio.br/har#ixzz38FV02q3s


### Methodology
The methodology below was used in predicting each of the five categories of exercise performance.

The data was first imported, a random seed was set and the training data was split up into a training set and a test validation set.  The training set used 75% of the training data in order to give an adequate amount of data to the model but still leave enough data for the testing set to validate the model. The a cross-validation set with unknown classes was also loaded in order to test the model against unknown classes.


```r
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
library(kernlab)
set.seed(42)

harData <- read.csv("Data/pml-training.csv")

inTrain <- createDataPartition(y=harData$classe, p=0.75, list=FALSE)

trainData <- harData[inTrain,]
testData <- harData[-inTrain,]

cvData <- read.csv("Data/pml-testing.csv")
```




After performing a tabular review of the data, it was noticed that a large number of columns contained NA values.  Therefore, the author decided to strictly use sensor data which was defined as any column with a name beginning with "gyros", "roll", "yaw" or "accel".  This resulted in a total of **36** features being used for the prediction model.  The training, test and cross validation sets were then stripped down to only include the columns of interest.  The columns used were as follows:

roll_belt, pitch_belt, yaw_belt, gyros_belt_x, gyros_belt_y, gyros_belt_z, accel_belt_x, accel_belt_y, accel_belt_z, roll_arm, pitch_arm, yaw_arm, gyros_arm_x, gyros_arm_y, gyros_arm_z, accel_arm_x, accel_arm_y, accel_arm_z, roll_dumbbell, pitch_dumbbell, yaw_dumbbell, gyros_dumbbell_x, gyros_dumbbell_y, gyros_dumbbell_z, accel_dumbbell_x, accel_dumbbell_y, accel_dumbbell_z, roll_forearm, pitch_forearm, yaw_forearm, gyros_forearm_x, gyros_forearm_y, gyros_forearm_z, accel_forearm_x, accel_forearm_y, accel_forearm_z


```r
dcols <- names(cvData)[grepl("^gyros|^roll|^pitch|^yaw|^accel", names(cvData))]

yTrain <- trainData[,"classe"]
yTest <- testData[,"classe"]

trainData <- trainData[,dcols]
testData <- testData[,dcols]
cvData <- cvData[,dcols]
```

Due to its historic success in prediction accuracy in low dimensional space, a random forest classifier was initially selected in order to predict the five classes.  While the approach is a bit of a black box and hard to interpret, the author's main goal was prediction accuracy.  The author believed that the prediction accuracy could be improved and thus switched to an Extra Trees Classifier, which is an even more randomized random forest.  The classifier was trained with the following code:


```
## Loading required package: randomForest
## randomForest 4.6-7
## Type rfNews() to see new features/changes/bug fixes.
```


```r
clf <- train(trainData, y = yTrain, method="rf")

pred <- predict(clf, testData)
```

### Results
After training the Random Forest Classifier, the model was used to predict the values for the test set.  The predicted values versus the actual values were then evaluated with a confusion matrix.


```r
table(pred, yTest)
```

```
##     yTest
## pred    A    B    C    D    E
##    A 1394    5    0    0    0
##    B    0  944    3    0    0
##    C    1    0  850    9    0
##    D    0    0    2  795    1
##    E    0    0    0    0  900
```

```r
cm <- confusionMatrix(table(pred, yTest))
cm
```

```
## Confusion Matrix and Statistics
## 
##     yTest
## pred    A    B    C    D    E
##    A 1394    5    0    0    0
##    B    0  944    3    0    0
##    C    1    0  850    9    0
##    D    0    0    2  795    1
##    E    0    0    0    0  900
## 
## Overall Statistics
##                                         
##                Accuracy : 0.996         
##                  95% CI : (0.993, 0.997)
##     No Information Rate : 0.284         
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.995         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity             0.999    0.995    0.994    0.989    0.999
## Specificity             0.999    0.999    0.998    0.999    1.000
## Pos Pred Value          0.996    0.997    0.988    0.996    1.000
## Neg Pred Value          1.000    0.999    0.999    0.998    1.000
## Prevalence              0.284    0.194    0.174    0.164    0.184
## Detection Rate          0.284    0.192    0.173    0.162    0.184
## Detection Prevalence    0.285    0.193    0.175    0.163    0.184
## Balanced Accuracy       0.999    0.997    0.996    0.994    0.999
```


### Discussion

```r
acc <- cm$overall[1]
```

This model is very promising as the overall accuracy is **0.9957**.

which leads to an out of sample error of **0.0043**.


It appears that the Random Forest Classifier was quite a good choice and showcases the prediction ability of random forest type models.  This model worked very well without much exploratory data analysis or feature engineering.
