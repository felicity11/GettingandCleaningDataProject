datapath<-file.path("./Project", "UCI HAR Dataset")

##### STEP1 ####################################
#### Merges the training and the test sets to create one data set
# Load and process X_test & y_test data.
X_test <- read.table(file.path("test","X_test.txt"))
y_test <- read.table(file.path("test","y_test.txt"))
subject_test <- read.table(file.path("test","subject_test.txt"))

# Load and process X_train & y_train data.
X_train <- read.table(file.path("train", "X_train.txt"))
y_train <- read.table(file.path("train", "y_train.txt"))
subject_train <- read.table(file.path("train","subject_train.txt"))

# Load: data column names
features <- read.table(file.path("features.txt"))[,2]

#Merges the training and the test sets to create one data set.
#Concatenate the data tables by rows
dataSubject <- rbind(subject_train,subject_test)
dataActivity<- rbind(y_train, y_test)
dataFeatures<- rbind(X_train, X_test)

#set names to variables
names(dataSubject)<- "subject"
names(dataActivity)<-"activity"
names(dataFeatures)<-features

#Merge columns to get the data frame Data for all data
data <- cbind(dataFeatures,dataSubject, dataActivity)
dim(data)

############# STEP2 #############
## Extracts only the measurements on the mean and standard deviation
## for each measurement.
extract_features <- names(dataFeatures)[grep("mean\\(\\)|std\\(\\)",names(dataFeatures))]
subData<-data[,c(extract_features, "subject", "activity")]

################# STEP3 #####
###### Uses descriptive activity names to name the activities in the data set ##

#Read descriptive activity names from "activity_labels.txt"
activity_labels <- read.table(file.path("activity_labels.txt"))[,2]
subData$activity <- as.factor(subData$activity)
levels(subData$activity) <- activity_labels

############ STEP4 ######
##Appropriately labels the data set with descriptive variable names.##
names(subData)<-gsub("^t", "time", names(subData))
names(subData)<-gsub("^f", "frequency", names(subData))
names(subData)<-gsub("Acc", "Accelerometer", names(subData))
names(subData)<-gsub("Gyro", "Gyroscope", names(subData))
names(subData)<-gsub("Mag", "Magnitude", names(subData))
names(subData)<-gsub("BodyBody", "Body", names(subData))


######## STEP5 ###########
## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
library(plyr)
data2<-aggregate(. ~subject + activity, data=subData, FUN = "mean")
write.table(data2, file = "tidydata.txt",row.name=FALSE)

