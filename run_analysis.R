## loading dplyr library

library(dplyr)

## reading activity and features tables

activitylabels<- read.table("C:/Users/user1/Documents/UCI HAR Dataset/activity_labels.txt")
features<- read.table("C:/Users/user1/Documents/UCI HAR Dataset/features.txt")
activitylabels[,2] <- as.character(activitylabels[,2])

## creating char vector of features to use it as variable names to measurements
feature<- as.character(features[,2])

## changing directory to access training files

dir1<-setwd("C:/Users/user1/Documents/UCI HAR Dataset/train")

## reading and creating data frame for training
                       
x_train <- read.table(paste(sep = "", dir1, "/X_train.txt"))
y_train <- read.table(paste(sep = "", dir1, "/y_train.txt"))
s_train <- read.table(paste(sep = "", dir1, "/subject_train.txt"))

## adding descriptive variable names

names(x_train)<- feature
names(y_train)<- "Activity"
names(s_train)<- "Subject"

## changing directory to access test files

dir2<-setwd("C:/Users/user1/Documents/UCI HAR Dataset/test")

## reading and creating data frame for test
x_test <- read.table(paste(sep = "", dir2, "/X_test.txt"))
y_test <- read.table(paste(sep = "", dir2, "/Y_test.txt"))
s_test <- read.table(paste(sep = "", dir2, "/subject_test.txt"))

## adding descriptive variable names

names(x_test)<- feature
names(y_test)<- "Activity"
names(s_test)<- "Subject"
## merging data sets

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

## selecting mean and stander deviation cols
selectedCols <- grep("-(mean|std).*", feature)
ColNames <- feature[selectedCols]

## merging all data sets

allData <- cbind(s_data, y_data, x_data)
allData$Activity <- factor(allData$Activity, levels = activitylabels[,1], labels = activitylabels[,2])

##mean data

meandata<-allData%>% group_by(Subject)%>% select(ColNames)

write.table(meandata, "./meandata.txt", row.names = FALSE, quote = FALSE)

##calculating average for each measurement in each subject

avgdata<- sapply(meandata, mean)
names(avgdata)<- "Meanforsubject"

##saving avgdata to txt file
write.table(avgdata, "./avg.txt", row.names = FALSE, quote = FALSE)
