library(here)
library(tidyverse)


# load data
# The here package help one build relative path regardless of platform (I work
# on both Windows and Mac). The point is to have anyone run the script without
# specifying the path using setwd()
data <- here("data")

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2
    FUCI%20HAR%20Dataset.zip"

destfile <- "data/uci.zip"
if(!file.exists(destfile)){
    res <- tryCatch(download.file(fileURL,
                                  destfile="data/uci.zip",
                                  method="auto"),
                    error=function(e) 1)
 }

unzip("data/uci.zip", exdir=data, overwrite = TRUE)

datauci <- here("data", "UCI HAR Dataset")
xtest <- read.table(file.path(here("data", "UCI HAR Dataset", "test", 
                    "X_test.txt")),header = FALSE)
ytest <- read.table(file.path(here("data", "UCI HAR Dataset", "test", 
                    "y_test.txt")),header = FALSE)
subjtest <- read.table(file.path(here("data", "UCI HAR Dataset", "test", 
                       "subject_test.txt")),header = FALSE)

xtrain <- read.table(file.path(here("data", "UCI HAR Dataset", "train", 
                     "X_train.txt")),header = FALSE)
ytrain <- read.table(file.path(here("data", "UCI HAR Dataset", "train", 
                     "y_train.txt")),header = FALSE)
subjtrain <- read.table(file.path(here("data", "UCI HAR Dataset", "train", 
                       "subject_train.txt")),header = FALSE)

ft <- read.table(file.path(here("data", "UCI HAR Dataset", "features.txt")), 
                 header = FALSE)
activi.lab <- read.table(file.path(here("data", "UCI HAR Dataset", 
						 "activity_labels.txt")), header = FALSE)

# data structure: 
# xtrain/xtest -> labeled by features
# ytrain/ytest -> labeled by activity
# subjecttrat/subjecttest -> labeled by subject


# append data & name variables
colnames(xtest) <- ft[,2]
colnames(xtrain) <- ft[,2]
d.feature <- rbind(xtest, xtrain)

d.activity <- rbind(ytest, ytrain)
d.subject <- rbind(subjtest, subjtrain)

names(d.activity) <- c("activityID")
names(d.subject) <- c("subjectID")
names(activi.lab) <- c("activityID", "activityType")

# 1. merge training and testing sets to create one dataset
mush <- bind_cols(d.feature, d.activity, d.subject)

# 2. extract variables containing "mean" or "std" for each measurement
ftnames <- ft$V2[grep("mean\\(\\)|std\\(\\)", ft$V2)]
bynames <- c(as.character(ftnames), "subjectID", "activityID")
mush2 <- subset(mush, select = bynames)

# 3. uses descriptive activity names to name the activities in the data set
mush2 <- left_join(mush2, activi.lab, by = "activityID")

# 4. Appropriately labels the data set with descriptive variable names
names(mush2)<-gsub("^t", "time", names(mush2))
names(mush2)<-gsub("^f", "frequency", names(mush2))
names(mush2)<-gsub("Acc", "Accelerometer", names(mush2))
names(mush2)<-gsub("Gyro", "Gyroscope", names(mush2))
names(mush2)<-gsub("Mag", "Magnitude", names(mush2))
names(mush2)<-gsub("BodyBody", "Body", names(mush2))

# 5.  creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject
mush3 <- aggregate(. ~ subjectID + activityType, mush2, mean)
mush3 <- mush3[order(mush3$subjectID, mush3$activityType),]
write.table(mush3, file.path(here("data","tidydata.txt")), row.names = FALSE)

