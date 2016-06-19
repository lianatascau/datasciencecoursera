if(!file.exists("./data")){
        dir.create("./data")
}
#  make handle
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#  download and unzip the dataset
download.file(fileURL, destfile = "projectzip", method = "curl", extra='-L')
project <- unzip("projectzip")

# 1. Merges the training and the test sets to create one data set

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, Y_train, X_train)

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, Y_test, X_test)

alldata <- rbind(train, test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# first load activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[[2]] <- as.character(activityLabels[[2]])
features <- read.table("UCI HAR Dataset/features.txt")
features[[2]] <- features[[2]]

# Step 4: extract all mean and standard deviation data from the alldata db
# give all the columns their proper names
mean.std <- grep(".*mean.*|.*std.*", features[,2])
mean.std.names <- features[mean.std,2]
mean.std.alldata <- alldata[,mean.std]
colnames(mean.std.alldata) <- mean.std.names
mean.std.alldata <- cbind(alldata[,1:2], mean.std.alldata)
colnames(mean.std.alldata)[1] <- "subject"
colnames(mean.std.alldata)[2] <- "activity"

# making the tidy data
# From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)
tidy.table <- melt(mean.std.alldata, id.vars = c("subject", "activity"))
tidy.table1 <- dcast(tidy.table, subject + activity ~ variable, mean)
# and the dimensions of the table decreased from 4 X 813621 to 81 X 180 (223 times )

