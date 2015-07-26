library(dplyr)

# read datasets
activity_labels=read.table("./UCI HAR Dataset/activity_labels.txt", header=F)
features=read.table("./UCI HAR Dataset/features.txt", header=F)

x_test=read.table("./UCI HAR Dataset/test/x_test.txt", header=F)
y_test=read.table("./UCI HAR Dataset/test/y_test.txt", header=F)
subject_test=read.table("./UCI HAR Dataset/test/subject_test.txt", header=F)

x_train=read.table("./UCI HAR Dataset/train/x_train.txt", header=F)
y_train=read.table("./UCI HAR Dataset/train/y_train.txt", header=F)
subject_train=read.table("./UCI HAR Dataset/train/subject_train.txt", header=F)

# descriptive variable names
colnames(x_test) <- features$V2
colnames(x_train) <- features$V2

# extract measurements on the mean and standard deviation
extractMeasures <- grep("mean()|std()", features$V2, value = FALSE)
x_test <- x_test[,extractMeasures]
x_train <- x_train[,extractMeasures]

# descriptive activity names
y_test <- left_join(y_test,activity_labels,by="V1")
y_train <- left_join(y_train,activity_labels,by="V1")


# desccriptive columnnames
colnames(y_test) <- c('V1','activity')
colnames(subject_test) <- c('subject')
colnames(y_train) <- c('V1','activity')
colnames(subject_train) <- c('subject')

# bind columns
df_test <- bind_cols(y_test,x_test)
df_test <- bind_cols(subject_test,df_test)
df_train <- bind_cols(y_train,x_train)
df_train <- bind_cols(subject_train,df_train)
# delete column V1
df_test <- df_test[,-2]
df_train <- df_train[,-2]

# merge test and training set
df <- union(df_test,df_train)

# second independent tidy data set
df_tidy<- (df %>%
            group_by(subject,activity) %>%
            summarise_each(funs( mean)))
