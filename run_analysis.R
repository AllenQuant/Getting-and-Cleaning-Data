## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive activity names.
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

getdata <- function(x) {
        # path to project directory
        directory <- "UCI HAR Dataset/"
        read.table(paste0(directory, x))
}

## Train datasets
subject_train <- getdata("train/subject_train.txt")
train_label <- getdata("train/y_train.txt")
train <- getdata("train/X_train.txt")

## Test datasets
subject_test <- getdata("test/subject_test.txt")
test_label <- getdata("test/y_test.txt")
test <- getdata("test/X_test.txt")

## labels
activity_labels <- getdata("activity_labels.txt")
features <- getdata("features.txt")

## Merge
data <- rbind(train, test)

####  Extract measurements on mean and standard deviation, fix variable names
#### *** Extracts only feature columns with mean(), meanFreq(),
####     or std() as part of title ***
inds <- grep("mean()|std()", features[, 2])
data <- data[, inds]

## Tidy feature names and rename data
clean_features <- sapply(features[, 2], function(x) gsub("[()]", "", x))
clean_features <- sapply(clean_features, function(x) gsub("[-,]", "_", x))
names(data) <- clean_features[inds]

## Add subject and activity columns, rename activities
data$subject <- c(subject_train[,1], subject_test[,1])
data$activity <- c(train_label[,1], test_label[,1])
data$activity <- sapply(data$activity, function(x) activity_labels[x, 2])

## Create dataset with average of each variable
## for each activity and each subject
library(plyr)
avgs <- ddply(data, .(subject, activity), function(x) {
        cols <- !names(x) %in% c("activity", "subject")
        apply(x[, cols], 2, function(y) mean(as.numeric(y)))
} )

## Write data
write.table(data, "clean_data.txt")
