if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Reading trainings tables:
xTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
xTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Assign column names:
colnames(xTrain) <- features[,2] 
colnames(yTrain) <-"activityId"
colnames(subjTrain) <- "subjectId"

colnames(xTest) <- features[,2] 
colnames(yTest) <- "activityId"
colnames(subjTest) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# Merge into one set
trainMerge <- cbind(yTrain, subjTrain, xTrain)
testMerge <- cbind(yTest, subjTest, xTest)
allSet <- rbind(trainMerge, testMerge)

# Getting Mean and Standard Deviation for each measurement

colNames <- colnames(allSet)

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames)) 

setMean_and_std <- allSet[ , mean_and_std == TRUE]

activityNames <- merge(setMean_and_std, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# 2nd tidy set with average of each variable for each activity and each subject

secSet <- aggregate(. ~subjectId + activityId, activityNames, mean)
secSet <- secSet[order(secSet$subjectId, secSet$activityId),]

# Write 2nd set in a text file
write.table(secSet, "secSet.txt", row.name=FALSE)