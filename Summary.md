# Predicting Quality of Weight Lifting from Sensors
## Eric Koziol

### Summary
This investigation attempts to predict the if a subject is performing a dumbell exercise correctly or incorrectly.  Incorrect performance of the exercise was broken down into a total of four different types, for a total of five categorical classification classes.  Using random forest techniques, the author was able to obtain a prediction accuracy of 99.7%.

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
## Warning: package 'caret' was built under R version 3.1.1
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
library(kernlab)
```

```
## Warning: package 'kernlab' was built under R version 3.1.1
```

```r
set.seed(42)

harData <- read.csv("Data/pml-training.csv")

inTrain <- createDataPartition(y=harData$classe, p=0.75, list=FALSE)

trainData <- harData[inTrain,]
testData <- harData[-inTrain,]

cvData <- read.csv("Data/pml-testing.csv")
```




After performing a tabular review of the data, it was noticed that a large number of columns contained NA values.  Therefore, the author decided to strictly use sensor data which was defined as any column with a name beginning with "gyros", "roll", "yaw" or "accel".  This resulted in a total of 36 being used for the prediction model.  The columns used were as follows:

roll_belt, pitch_belt, yaw_belt, gyros_belt_x, gyros_belt_y, gyros_belt_z, accel_belt_x, accel_belt_y, accel_belt_z, roll_arm, pitch_arm, yaw_arm, gyros_arm_x, gyros_arm_y, gyros_arm_z, accel_arm_x, accel_arm_y, accel_arm_z, roll_dumbbell, pitch_dumbbell, yaw_dumbbell, gyros_dumbbell_x, gyros_dumbbell_y, gyros_dumbbell_z, accel_dumbbell_x, accel_dumbbell_y, accel_dumbbell_z, roll_forearm, pitch_forearm, yaw_forearm, gyros_forearm_x, gyros_forearm_y, gyros_forearm_z, accel_forearm_x, accel_forearm_y, accel_forearm_z


```r
dcols <- names(cvData)[grepl("^gyros|^roll|^pitch|^yaw|^accel", names(cvData))]

yTrain <- trainData[,"classe"]
yTest <- testData[,"classe"]

trainData <- trainData[,dcols]
testData <- testData[,dcols]
cvData <- cvData[,dcols]
```

### Results

### Discussion

### Conclusion
