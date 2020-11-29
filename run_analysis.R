# reading features and activity data

features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

# reading train data

train <- read.table("./UCI HAR Dataset/train/X_train.txt") #features data
colnames(train) <- features$V2 #descriptive column names for data (STEP 4)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") #activity labels
train$activity <- y_train$V1
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") #subjects
train$subject <- factor(subject_train$V1)


# reading test data

test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(test) <- features$V2
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
test$activity <- y_test$V1
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test$subject <- factor(subject_test$V1)

# 1.merge train and test sets

dataset <- rbind(test, train) 

# 2.filter column names

column.names <- colnames(dataset)
#get only columns for standard deviation and mean values, also saves activity and subject values 
column.names.filtered <- grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
dataset.filtered <- dataset[, column.names.filtered] 

# 3.adding descriptive values for activity labels

dataset.filtered$activitylabel <- factor(dataset.filtered$activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#creating a tidy dataset with mean values for each subject and activity

features.colnames = grep("std\\(\\)|mean\\(\\)", column.names, value=TRUE)
dataset.melt <-melt(dataset.filtered, id = c('activitylabel', 'subject'), measure.vars = features.colnames)
dataset.tidy <- dcast(dataset.melt, activitylabel + subject ~ variable, mean)
                                         
#creating a tidy dataset file  
write.table(dataset.tidy, file = "tidydataset.txt" row.names = FALSE)
