library(dplyr)

# 1. Merge training and test sets
X <- rbind(read.table("train/X_train.txt"), read.table("test/X_test.txt"))
Y <- rbind(read.table("train/y_train.txt"), read.table("test/y_test.txt"))
Subject <- rbind(read.table("train/subject_train.txt"), read.table("test/subject_test.txt"))

# 2. Extract only mean and standard deviation
features <- read.table("features.txt")
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
X <- X[, mean_std_features]
names(X) <- features[mean_std_features, 2]

# 3. Use descriptive activity names
activities <- read.table("activity_labels.txt")
Y[, 1] <- activities[Y[, 1], 2]
names(Y) <- "activity"

# 4. Label data set with descriptive variable names
names(Subject) <- "subject"
all_data <- cbind(Subject, Y, X)
names(all_data) <- gsub("^t", "Time", names(all_data))
names(all_data) <- gsub("^f", "Frequency", names(all_data))
names(all_data) <- gsub("Acc", "Accelerometer", names(all_data))

# 5. Create second independent tidy data set with averages
tidy_data <- all_data %>%
    group_by(subject, activity) %>%
    summarise_all(mean)

write.table(tidy_data, "TidyData.txt", row.name=FALSE)
