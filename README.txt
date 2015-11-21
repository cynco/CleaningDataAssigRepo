To run this script:
Have the UCI-HAR_Dataset in your working directory. (Note underscores in directory name)
Have the data table and accompanying packages in your R library. 
In the R console, enter source(“run_analysis.R”

The two data sets produced are named "fullMeasurementsdt" and "averageMeasurementsdt" .

##### This R script does the following: 
##	((1)) Merges the training and the test sets to create one data set.
##	((2)) Extracts only the measurements on the mean and standard deviation for each measurement. 
##	((3)) Uses descriptive activity names to name the activities in the data set
##	((4)) Appropriately labels the data set with descriptive variable names. 
##	((5)) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The original data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


