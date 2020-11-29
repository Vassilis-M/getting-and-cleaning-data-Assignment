#Download the dataset

filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
#******************************************************************
#Step 1.Merges the training and the test sets to create one data set.
#******************************************************************

# 1.1 Reading files

# 1.1.1  Reading trainings tables:

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# 1.1.2 Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# 1.1.3 Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# 1.1.4 Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# 1.2 Assigning column names:

colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#1.3 Merging all data in one set:

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

#dim(setAllInOne)
#[1] 10299   563

#******************************************************************
#Step 2.-Extracts only the measurements on the mean and standard deviation for each measurement.
#******************************************************************

#2.1 Reading column names:

colNames <- colnames(setAllInOne)

#2.2 Create vector for defining ID, mean and standard deviation:

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#2.3 Making nessesary subset from setAllInOne:

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#******************************************************************
#Step 3. Uses descriptive activity names to name the activities in the data set
#******************************************************************

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#******************************************************************
#Step 4. Appropriately labels the data set with descriptive variable names.
#******************************************************************

#Done in previous steps, see 1.3,2.2 and 2.3!

#******************************************************************
#Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#******************************************************************

#5.1 Making a second tidy data set

TidyDataSet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidyDataSet <- TidyDataSet[order(TidyDataSet$subjectId, TidyDataSet$activityId),]

#5.2 Writing second tidy data set in txt file

write.table(TidyDataSet, "TidyDataSet.txt", row.name=FALSE)
