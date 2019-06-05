### CodeBook

These are the 561 attribute names:
featureNames <- features.txt 

These are the 6 activity names with their respective number:
activityLabels <- activity_labels.txt

The ID of the subject who performed the activity. IDs range from 1 to 30:
subjectTrain <- subject_train
subjectTest <- subject_test

The activity that the subject performed:
activityTrain <- y_train
activityTest <- y_test

The values of the 561 attributes per subject:
featuresTrain <- X_train
featuresTest <- X_test

combinedData <- merging all the training and testing data together

MeanSTD_DF <- this data is a subset of the indices of the combinedData where the column name contains Mean or STD

Final_Data <- is the final dataset which contains only specific columns that contain Mean/STD and the names of the activities perfromed

Variables corrected: Acc, Gyro, BodyBody, Mag, t, and f
Now the variables are Accelerometer, Gyroscope, Body, Magnitude, Time, Frequency

tidyData <- this is the data set when the mean of all the values per subject and activity are taken

