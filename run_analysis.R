rm(list=ls())

library(reshape2)

# gets features to be included
feats <- read.table("UCI HAR Dataset/features.txt") 
feats[,2] <- as.character(feats[,2]) 
featsIncl <- grep(".*mean.*|.*std.*", feats[,2]) 
featsIncl.names <- feats[featsIncl,2] 
featsIncl.names = gsub('-mean', 'Mean', featsIncl.names) 
featsIncl.names = gsub('-std', 'Std', featsIncl.names) 
featsIncl.names <- gsub('[-()]', '', featsIncl.names) 

# load  datasets 
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")[featsIncl] 
ytest <- read.table("UCI HAR Dataset/test/Y_test.txt") 
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt") 
test <- cbind(testSubjects, ytest, xtest) 

xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")[featsIncl] 
ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt") 
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt") 
train <- cbind(trainSubjects, ytrain, xtrain) 

# merge data
allData <- rbind(train, test) 
colnames(allData) <- c("subject", "activity", featsIncl.names) 

# load activities
actLabs <- read.table("UCI HAR Dataset/activity_labels.txt") 
actLabs[,2] <- as.character(actLabs[,2]) 

# create factors 
allData$activity <- factor(allData$activity, levels = actLabs[,1], labels = actLabs[,2]) 
allData$subject <- as.factor(allData$subject) 

# average of each variable for each activity and each subject
allData.melted <- melt(allData, id = c("subject", "activity")) 
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean) 

# write data
write.table(allData.mean, "tidyData.txt", row.names = FALSE, quote = FALSE) 

# view data
tidyData <- read.table("tidyData.txt")
View(tidyData)