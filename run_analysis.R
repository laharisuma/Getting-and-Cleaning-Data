library(reshape2)

##read data into df
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
X_test <- read.table("test/X_test.txt")
y_train <- read.table("train/y_train.txt")
y_test <- read.table("test/y_test.txt")
activity_labels <- read.table("activity_labels.txt")
names(y_train) <-"activity"
names(y_test) <-"activity"
features <- read.table("features.txt")
names(X_train) <- feature$V2
names(X_test) <- feature$V2

##Step 1: Merges the training and the test sets to create one data set.
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)


## STEP 2: Extracts only the measurements on the mean and standard
MeanStdOnly <- grepl("mean\\(\\)", names(combined)) |
  grepl("std\\(\\)", names(combined))
MeanStdOnly[1:2] <- TRUE


##Step 3 & 4: Uses descriptive activity names to name the activities in the data set & labelling
combined$activity <- factor(combined$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

##Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
overallData <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(overallData, subjectID+activity ~ variable, mean)
write.csv(tidy, "tidy.csv", row.names=FALSE)
