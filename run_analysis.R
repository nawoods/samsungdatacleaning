library(dplyr)

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
results <- data.frame(subject = paste(readLines(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))))


# parsing activity labels
activity.labels <- paste(readLines(unz(temp,"UCI HAR Dataset/activity_labels.txt")))
activity.labels <- sub("^[1-6] ","",activity.labels,)
activity.labels <- tolower(activity.labels)
gsub("_","",activity.labels,)

# add activity to each observation
y.test <- paste(readLines(unz(temp, "UCI HAR Dataset/test/y_test.txt")))
y.test <- as.numeric(y.test)
results$activity <- sapply(y.test, function(x) activity.labels[x])

features <- paste(readLines(unz(temp, "UCI HAR Dataset/features.txt")))
features <- sub("^[0-9]+ ","",features)
ourFields <- grep("-mean\\(|-std\\(",features)

x.test <- paste(readLines(unz(temp,"UCI HAR Dataset/test/X_test.txt")))
x.test <- sub("^ +","",x.test,)
x.test <- strsplit(x.test," +")
x.test <- lapply(x.test, function(x) x[ourFields])
vectorGetter <- function (m) sapply(x.test, function(x) x[m])
newValues <- data.frame(sapply(1:66, function(x) as.numeric(vectorGetter(x))))

#reaname the variables
ourFeatures <- grep("-mean\\(|-std\\(",features,value=T)
ourFeatures <- tolower(ourFeatures)
ourFeatures <- gsub("^t","timedomainsignalof",ourFeatures)        
ourFeatures <- gsub("^f","frequencydomainsignalof",ourFeatures)
ourFeatures <- gsub("mean\\(\\)","mean",ourFeatures)
ourFeatures <- gsub("std\\(\\)","standarddeviation",ourFeatures)
ourFeatures <- gsub("-x$","alongxaxis",ourFeatures)
ourFeatures <- gsub("-y$","alongyaxis",ourFeatures)
ourFeatures <- gsub("-z$","alongzaxis",ourFeatures)
ourFeatures <- gsub("acc-","acceleration",ourFeatures)
ourFeatures <- gsub("accjerk-","jerkfromacceleration",ourFeatures)
ourFeatures <- gsub("gyro-","angularvelocity",ourFeatures)
ourFeatures <- gsub("gyrojerk-","jerkfromangularvelocity",ourFeatures)
ourFeatures <- gsub("accmag-","accelerationmagnitude",ourFeatures)
ourFeatures <- gsub("accjerkmag-","jerkfromaccelerationmagnitude",ourFeatures)
ourFeatures <- gsub("gyromag-","angularvelocitymagnitude",ourFeatures)
ourFeatures <- gsub("gyrojerkmag-","jerkfromangularvelocitymagnitude",ourFeatures)


#put the test dataset together
names(newValues) <- ourFeatures
results <- merge(results,newValues,by=0)

# do the same thing with the training data
results2 <- data.frame(subject = paste(readLines(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))))

y.train <- paste(readLines(unz(temp,"UCI HAR Dataset/train/y_train.txt")))
y.train <- as.numeric(y.train)
results2$activity <- sapply(y.train, function(x) activity.labels[x])

x.train <- paste(readLines(unz(temp,"UCI HAR Dataset/train/X_train.txt")))
x.train <- sub("^ +","",x.train,)
x.train <- strsplit(x.train," +")
x.train <- lapply(x.train, function(x) x[ourFields])
vectorGetter <- function (m) sapply(x.train, function(x) x[m])
newValues <- data.frame(sapply(1:66, function(x) as.numeric(vectorGetter(x))))
names(newValues) <- ourFeatures
results2 <- merge(results2,newValues,by=0)

#done with the zip file
unlink(temp)

#merge the datasets
results <- rbind(results,results2)
results <- results[,2:69]

#create a second data frame taking the mean of each variable in results
results <- group_by(results,subject,activity)
resultsMeans <- summarize_each(results,funs(mean))
resultsMeans
