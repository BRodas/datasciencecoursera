# Then I download the file and unzip it.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./accelerometers.zip")
unzip("accelerometers.zip")

###################################################
# USEFUL FUNCTIONS
###################################################
# This function helps to import the subject, X and Y files.
importingSets <- function(DataSet = c("training", "test")
                          , kind = c("subject", "x", "labels")){
  
  if(kind=="subject"){
    directory <- ifelse(DataSet=="training"
           , yes = paste0("train/","subject_train.txt")
           , no = paste0("test/","subject_test.txt"))
    name <- "subject"
    
  }else if(kind=="x"){
    directory <- ifelse(DataSet=="training"
           , yes = paste0("train/","X_train.txt")
           , no = paste0("test/","X_test.txt"))
    name <- read.table("UCI HAR Dataset/features.txt"
                       , quote="\""
                       , comment.char=""
                       , stringsAsFactors=FALSE)[,2]
    
  }else if(kind=="labels"){
    directory <- ifelse(DataSet=="training"
           , yes = paste0("train/","y_train.txt")
           , no = paste0("test/","y_test.txt"))
    name <- "label"
  }

  directory <- paste0("UCI HAR Dataset/", directory)
  X <- read.table(directory
                    , quote="\""
                    , comment.char=""
                    , stringsAsFactors=FALSE)
  
  colnames(X) <- name
  X
  }

###################################################
# Merges the training and the test sets to create one data set.
###################################################

# Importing Training set
TrainSet <- importingSets(DataSet = "training"
                          , kind = "x")
# Importing Test set
TestSet <- importingSets(DataSet = "test"
                         , kind = "x")

# Merging the Training and Test Set
MergeSet <- rbind(TrainSet, TestSet)

###################################################
# Extracts only the measurements on the mean and standard deviation for each measurement.
###################################################
# I select the indexes of the columns that I'm looking for
indexMean <- grep("mean", colnames(MergeSet))
indexStd <- grep("std", colnames(MergeSet))

MergeSet <- MergeSet[,c(indexMean, indexStd)]

###################################################
# Uses descriptive activity names to name the activities in the data set
###################################################
# Importing Training set
TrainLabel <- importingSets(DataSet = "training"
                          , kind = "labels")
# Importing Test set
TestLabel <- importingSets(DataSet = "test"
                         , kind = "labels")

# Merging the Training and Test Labels
labels <- rbind(TrainLabel, TestLabel)
# Merging the labels with the data set
MergeSet <- cbind(MergeSet, labels)
# Activity Names
MergeSet$label <- factor(MergeSet$label
                         , levels = 1:6
                         , labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS"
                                    ,"SITTING", "STANDING", "LAYING"))

###################################################
# Appropriately labels the data set with descriptive variable names.
###################################################
colnames(MergeSet) <- gsub("-", "_", colnames(MergeSet))
colnames(MergeSet) <- gsub("\\(\\)", "_", colnames(MergeSet))
colnames(MergeSet) <- gsub("__", "_", colnames(MergeSet))

write.csv(MergeSet, file="tidy_data_set.csv")

###################################################
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
###################################################
# Importing Training Subjects
TrainSubject <- importingSets(DataSet = "training"
                            , kind = "subject")
# Importing Test Subjects
TestSubject <- importingSets(DataSet = "test"
                           , kind = "subject")

# Merging the Training and Test Subjects
subjects <- rbind(TrainSubject, TestSubject)
subjects <- as.factor(subjects[,1])
# Merging the Subjects with the data set
MergeSet <- cbind(MergeSet, subjects)
# I work out the levels
interactions <- interaction(MergeSet$label, MergeSet$subjects, drop = TRUE)
# I split the data frame
list_interaction <- split(MergeSet[,1:79], interactions)
# then I work out the averages of all possible combinations
averages <- t(sapply(list_interaction, FUN = colMeans))

write.csv(averages, file="tidy_data_set_2.csv")
