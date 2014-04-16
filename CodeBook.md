Merges the training and the test sets to create one data set. 
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set. 
Appropriately labels the data set with descriptive activity names. 
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Read Train datasets subject_train <- read.table("train/subject_train.txt")

Test datasets subject_test <- read.table("test/subject_test.txt")

Read labels activity_labels <- read.table("activity_labels.txt")

Merge dataset data <- rbind(train, test)

Extract measurements on mean and standard deviation, fix variable names *** Extracts only feature columns with mean(), meanFreq(), or std() as part of title ***

Tidy feature names and rename dat clean_features <- sapply(features[, 2], function(x) gsub("[()]", "", x)) clean_features <- sapply(clean_features, function(x) gsub("[-,]", "_", x))

Add subject and activity columns, rename activities

Create dataset with average of each variable for each activity and each subject library(plyr) avgs <- ddply(dat, .(subject, activity), function(x) { cols <- !names(x) %in% c("activity", "subject") apply(x[, cols], 2, function(y) mean(as.numeric(y))) } )

Write data write.table(data, "clean_data.txt")
