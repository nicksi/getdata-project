# library load squence is important for plyr/dplyr, so let's try to unload them first
loaded_packages <- search()
if ( "package:plyr" %in% loaded_packages| "package:dplyr" %in% loaded_packages ) {
    detach(package:dplyr, unload = TRUE)
    detach(package:dplyr, unload = TRUE)
}
#Load dplyr after plyr
library("plyr")
library("dplyr")
library("tidyr")

##
## Step1: read and merge files
##
column_names_file <- "data/features.txt"
column_names <- read.table(column_names_file, stringsAsFactors=FALSE)

subject_file <- "data/test/subject_test.txt"
test_file <- "data/test/X_test.txt"
activity_file <- "data/test/y_test.txt"

subject <- read.table(subject_file, col.names = c("subject"))
activity <- read.table(activity_file, col.names = c("activity"))
test_data <- read.table(test_file)
# get rid of duplicates in names and illegal characters
# "()" will be replaced with ".."
# big thanks to hazem nasrat (https://class.coursera.org/getdata-010/forum/profile?user_id=9713754) for the pointer
names(test_data) <- make.names(column_names$V2, unique=TRUE)
test_data <- cbind(test_data, activity, subject)

data_file <- "data/train/X_train.txt"
activity_file <- "data/train/y_train.txt"
subject_file <- "data/train/subject_train.txt"

activity <- read.table(activity_file, col.names = c("activity"))
subject <- read.table(subject_file, col.names = c("subject"))
train_data <- read.table(data_file)
names(train_data) <- make.names(column_names$V2, unique=TRUE)
train_data <- cbind(train_data, activity, subject)

data <- tbl_df(rbind_list(test_data, train_data))

#clean unused data
rm("test_data")
rm("train_data")
rm("activity")
rm("subject")
rm("column_names")

##
## Step 2 - sleect columns
##
# mean() and std() parts of variable name has been converted to mean.. and std..
subset_data <- select(data, subject, activity, contains(".mean.."), contains(".std.."))

##
## Step 3 - improve column names
#clean extra dots
names(subset_data) <- gsub("\\.\\.","",names(subset_data))
# Clean wrong names
names(subset_data) <- gsub("BodyBody","Body",names(subset_data))

##
## Step 4 - update activities names
##
# Also make subject factor, not numeric
subset_data <- mutate(subset_data,
    activity = as.factor(
        mapvalues(activity,
                  from=1:6,
                  to = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                         "SITTING","STANDING","LAYING"))
        ),
    subject = as.factor(subject)
)

##
## Step 5 - aggregate and improve
##
# group_by do only one level grouping, so ddply and copnvert back to table
aggregated_data <- gather(subset_data, measure, value, -activity, -subject) # melt table
aggregated_data <- tbl_df(ddply(aggregated_data, c("subject", "activity", "measure"), summarize, value = mean(value))) #calculate means

aggregated_data <-
    aggregated_data %>%
    separate(measure, into=c("parameter","measure", "axis"), sep="\\.", extra="drop") %>%
    separate(parameter, into=c("mode", "parameter"), sep=1) %>%
    mutate(
        mode = as.factor(
            mapvalues(mode,
                      from=c("t","f"),
                      to = c("time","frequency"))
        ),
        axis = as.factor(axis),
        measure = as.factor(measure),
        component = as.factor(sub("^([A-Z].+?)([A-Z].*)","\\1",parameter)),
        datasource = as.factor(sub("^([A-Z].+?)([A-Z].+?)([A-Z].*|$)","\\2",parameter)),
        parameter = as.factor(sub("^([A-Z].+?)([A-Z].+?)([A-Z].*|$)","\\3",parameter))
    )

# save result to file
write.table(aggregated_data, "aggregate.txt", row.name=FALSE)
