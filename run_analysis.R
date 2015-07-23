## Getting and Cleaning Data Assignment
##
## You should create one R script called run_analysis.R that does the following. 
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("C:/data/backedup/trabalho/pessoais/formação/2015/15.06 Data Science Specialization/03 Geting and Cleaning Data/assignment/")

##
## STEP 1
## Merges the training and the test sets to create one data set
##

## Loading test data
test.xdata    <- read.table("UCI HAR Dataset/test/X_test.txt")
test.ydata    <- read.table("UCI HAR Dataset/test/Y_test.txt")
test.subject  <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Loading training data
train.xdata    <- read.table("UCI HAR Dataset/train/X_train.txt")
train.ydata    <- read.table("UCI HAR Dataset/train/Y_train.txt")
train.subject  <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Merge the data
xdata <- rbind(test.xdata, train.xdata)
ydata <- rbind(test.ydata, train.ydata)
subject <- rbind(test.subject, train.subject)

##
## STEP 2
## Extracts only the measurements on the mean and standard deviation for each measurement
##

## Loading comun data
labels   <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)[,2]
features <- read.table("UCI HAR Dataset/features.txt", header=FALSE)[,2]
features.to.keep <- grepl("mean|std", features)
## start off by setting column names
names(xdata) = features
## Just keep the data to work on
xdata = xdata[,features.to.keep]

##
## STEP 3
## Uses descriptive activity names to name the activities in the data set
##

ydata[,2] = labels[ydata[,1]]

##
## STEP 4
## Appropriately labels the data set with descriptive variable names
##
names(ydata) = c("Activity.ID", "Activity.Label")
names(subject) = "Subject"

##
## STEP 5
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
##

## Bind x data with y data
data <- cbind(subject, ydata, xdata)
## Load reshape 2 to use melt
require(reshape2)
row.labels   = c("Subject", "Activity.ID", "Activity.Label")
data.labels = setdiff(colnames(data), row.labels)
melt.data      = melt(data, id = row.labels, measure.vars = data.labels)

# Apply mean function to dataset using dcast function
tidy.data   = dcast(melt.data, Subject + Activity.Label ~ variable, mean)

write.table(tidy.data, file = "tidydata.txt", row.names=FALSE)




## To run, just copy & paste: source("C:/data/backedup/trabalho/pessoais/formação/2015/15.06 Data Science Specialization/03 Geting and Cleaning Data/assignment/run_analysis.R")
