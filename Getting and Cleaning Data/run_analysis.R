library(dplyr)

wd <- getwd()

subPath <- c(paste0(wd,"/UCI HAR Dataset/test/subject_test.txt"),paste0(wd,"/UCI HAR Dataset/train/subject_train.txt"))
xPath <- c(paste0(wd,"/UCI HAR Dataset/test/x_test.txt"),paste0(wd,"/UCI HAR Dataset/train/x_train.txt"))
yPath <- c(paste0(wd,"/UCI HAR Dataset/test/y_test.txt"),paste0(wd,"/UCI HAR Dataset/train/y_train.txt"))
featPath <- paste0(wd,"/UCI HAR Dataset/features.txt")
actLabPath <- paste0(wd,"/UCI HAR Dataset/activity_labels.txt")

# Union between both subject files
subject <- rbind(read.table(subPath[1]),read.table(subPath[2]))
names(subject) <- "subject"

# Union between both Y files
activities <- rbind(read.table(yPath[1]),read.table(yPath[2]))
names(activities) <- "activities"

# Union between both X files
data <- rbind(read.table(xPath[1]),read.table(xPath[2]))

# get Labels
featlab <- read.table(featPath)
featlab <- featlab[,2]

actLab <- read.table(actLabPath)
actLab <- actLab[,2]

# assign labels to data
featlab <- gsub("[-(),]","",featlab)
featlab <- gsub("mean","Mean",featlab)
names(data) <- gsub("std","Std",featlab)

# Get only required columns
required <- grep("*Mean|Std*", featlab)
data <- data[required]

# Create the dataSet
df <- tbl_df(cbind(subject,activities,data))

# Generate the tidy data table
df2 <- aggregate(df[,3:55],df[,1:2],mean)

# Export the data as CSV
tidyPath <- paste0(wd,"/tidyData.csv")
write.csv(df2,tidyPath)
