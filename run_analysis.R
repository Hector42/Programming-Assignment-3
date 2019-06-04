library(dplyr)
library(tidyr)
library(data.table)

## download data from website and unzip dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "dataset.zip", mode = "wb")
unzip("dataset.zip")

# Reading in the 561 attribute names 
featureNames <- read.table("UCI HAR Dataset/features.txt")
#Reading in the 6 activity names with their respective number
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

#Read in the ID of the subject who performed the activity. IDS range from 1 -30
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
#Read in the activity that the subject performed. Activitys range from 1 to 6
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
#Read in the value in the 561 attributes per subject
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

#Read in the same data as above, except this data is for the test sets
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#Merge the data of training and testing together
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

head(subject,n=40)  ###10,299 rows of the test subjects ID
head(activity,n=40) ###10,299 rows of the the activity label the test subject was doing
head(features,n=1) ###10,299 rows of the values that were taken per test subject

head(featureNames,n=200)

#we want to take the names in the features and place them in the correct positions on the features data table
#the function t will return the transpose of the matrix or dataframe and the [2] means take the second row and 
#replace the column names of features with it
colnames(features) <- t(featureNames[2])

#Give the subject and activity data frames column names as well
colnames(subject) <- "Subject_ID"
colnames(activity) <- "Activity_Label"

#Merge the data together by columns
combinedData <- cbind(subject,activity,features)
combinedData

names(combinedData)
#take a subset of the data where the column names contain either Mean or Std and case does not matter
#this subset includes just the indices in which there is a pattern match
MeanSTD_DF <- grep(".*Mean.*|.*Std.*", names(combinedData), ignore.case=TRUE)
MeanSTD_DF

##You need to add the Subject ID and Activity label to the subsetted data
specifiedColumns <- c(1,2,MeanSTD_DF)
specifiedColumns

##Now you can filter the combinedData for all the rows and just the specifiedColumns to give you the final Data Frame
Final_Data <- combinedData[,specifiedColumns]
dim(Final_Data)

##Now we must use the activity labels to name the activities in the final data 
#first change the activity column from numeric to character
Final_Data$Activity_Label <- as.character(Final_Data$Activity_Label)

#the for loop will place the names of the activity where the numbers match
for (i in 1:6){
  Final_Data$Activity_Label[Final_Data$Activity_Label == i] <- as.character(activityLabels[i,2])
}

Final_Data

#find the abbreviated characters and then replace them with the full word
names(Final_Data)<-gsub("Acc", "Accelerometer", names(Final_Data))
names(Final_Data)<-gsub("Gyro", "Gyroscope", names(Final_Data))
names(Final_Data)<-gsub("BodyBody", "Body", names(Final_Data))
names(Final_Data)<-gsub("Mag", "Magnitude", names(Final_Data))
names(Final_Data)<-gsub("^t", "Time", names(Final_Data))
names(Final_Data)<-gsub("^f", "Frequency", names(Final_Data))

#Create the Factors
Final_Data$Activity_Label <- as.factor(Final_Data$Activity_Label)
Final_Data$Subject_ID <- as.factor(Final_Data$Subject_ID)

Final_Data <- data.table(Final_Data)
Final_Data

#where subject_ID and activity label are the same, take the the mean of all the values
tidyData <- aggregate(. ~Subject_ID + Activity_Label, Final_Data, mean)
tidyData <- tidyData[order(tidyData$Subject_ID,tidyData$Activity_Label),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)