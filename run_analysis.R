# Imports
library(dplyr)

# Read all text files and assign new columns names
features <- read.table("data\\features.txt", col.names = c("n","functions"))
activities <- read.table("data\\activity_labels.txt", col.names = c("code", "activity"))
subtest <- read.table("data\\test\\subject_test.txt", col.names = "subject")
xtest <- read.table("data\\test\\X_test.txt", col.names = features$functions)
ytest <- read.table("data\\test\\y_test.txt", col.names = "code")
subtrain <- read.table("data\\train\\subject_train.txt", col.names = "subject")
xtrain <- read.table("data\\train\\X_train.txt", col.names = features$functions)
ytrain <- read.table("data\\train\\y_train.txt", col.names = "code")

# 1. Merging the data (test + train)
x <- rbind(xtrain, xtest); y <- rbind(ytrain, ytest)
subject <- rbind(subtrain, subtest)
fulldata <- cbind(subject, y, x)
# Looking at untyding data
str(fulldata)

# 2. Extract mean and SD 
TD <- fulldata %>%
      select(subject, code, contains("mean"), contains("std"))

# 3.  Uses descriptive activity names to name the activities in the data set.
TD$code <- activities[TD$code, 2]

# 4. Rename labels
names(TD)[2] = "activity"
names(TD)<-gsub("Acc", "Accelerometer", names(TD))
names(TD)<-gsub("BodyBody", "Body", names(TD))
names(TD)<-gsub("Mag", "Magnitude", names(TD))
names(TD)<-gsub("Gyro", "Gyroscope", names(TD))
names(TD)<-gsub("^t", "Time", names(TD))
names(TD)<-gsub("^f", "Frequency", names(TD))
names(TD)<-gsub("tBody", "TimeBody", names(TD))
names(TD)<-gsub("angle", "Angle", names(TD))
names(TD)<-gsub("gravity", "Gravity", names(TD))
names(TD)<-gsub("-mean()", "Mean", names(TD), ignore.case = TRUE)
names(TD)<-gsub("-freq()", "Frequency", names(TD), ignore.case = TRUE)
names(TD)<-gsub("-std()", "StandardDeviation", names(TD), ignore.case = TRUE)
names(TD)<-gsub("-freq()", "Frequency", names(TD), ignore.case = TRUE)

done <- TD %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))

# Write to final text file 
write.table(done, "done.txt", row.name=FALSE)

# Final result
str(done)