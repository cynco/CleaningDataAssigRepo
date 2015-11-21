##Script: run_analysis.R

##### This R script does the following: 
##	((1)) Merges the training and the test sets to create one data set.
##	((2)) Extracts only the measurements on the mean and standard deviation for each measurement. 
##	((3)) Uses descriptive activity names to name the activities in the data set
##	((4)) Appropriately labels the data set with descriptive variable names. 
##	((5)) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##### Description of files used:
## subject_test.txt gives the participant id for every subject and every time step. nrows1=nsubject x ntstp.
## x gives 561 measurements (variables/columns) for nrows1. dim nrows1x561
## y gives the activity id for nrows1. dim nrows1x1
## features is the list of labels for the 561 measurements. dim 561x2
##		some feature names in features are identical 
##		but correspond to different measurements.
## activity_labels gives activity corresponding 
## test has data for 9 subjects
## train has data for 21 subjects

## Using data table approach
library(data.table)
## Set path to enclosing directory
uci<-paste(getwd(), "/UCI_HAR_Dataset/" , sep="")
## Load data sets from files and merge train and test parts - Step ((1))
featdt<-fread(file.path(uci,"features.txt"))
actdt<-fread(file.path(uci,"activity_labels.txt"))

subtrain<-fread(file.path(uci,"train/subject_train.txt"))
subtest<-fread(file.path(uci,"test/subject_test.txt"))
subdt<-rbind(subtrain,subtest)
rm(subtrain,subtest)
colnames(subdt)[1]<-"subject"

ytrain<-fread(file.path(uci,"train/y_train.txt"))
ytest<-fread(file.path(uci,"test/y_test.txt"))
ydt<-rbind(ytrain,ytest)
rm(ytrain,ytest)
colnames(ydt)[1]<-"activity"

xtrain<-fread(file.path(uci,"train/X_train.txt"))
xtest<-fread(file.path(uci,"test/X_test.txt"))
xdt<-rbind(xtrain,xtest)
rm(xtrain,xtest)

## Keep only the means and starndard deviation variables      - Step ((2))
mfeat<-grep("mean()|std()", featdt[[2]]) #indexes of matching feature names
featdt<-featdt[mfeat,1:2,with=FALSE]

## Fix any duplicate names by pasting position number. - not needed
## Ex. "fBodyAcc-bandsEnergy()-9,16-318"
#dupes<-which(duplicated(featdt[[2]]))
#featdt[[2]][dupes]<-paste(featdt[[2]][dupes], featdt[[1]][dupes], sep="-") 
#rm(dupes)

## Extract corresponding mean and std variables in xdt
xdt <- xdt[ ,mfeat, with=FALSE]   #improve using :=NULL
rm(mfeat)

## Replace numbers with descriptive values for activities in ydt - Step ((3))
setattr(ydt[[1]],"class","factor")
setattr(ydt[[1]],"levels", actdt[[2]])
	
## Give descriptive names to xdt variables/columns             - Step ((4))
setnames(xdt,featdt[[2]])	

## Join subject and activity as first two columns of xdt
xdt[,subject:=subdt[[1]]]
xdt[,activity:=ydt[[1]]]
setcolorder(xdt,c("subject","activity",featdt[[2]]))

## Create a separate data set of the means of the feature columns 
## grouped by subject and activity                             - Step ((5))

avgdt<-xdt[,lapply(.SD,mean),by=.(activity,subject),.SDcols=3:ncol(xdt)]

## Rename some avgdt columns
maxncol<-ncol(avgdt)
names(avgdt)[3:maxncol]<-paste("Avg",names(avgdt)[3:maxncol],sep="_")

## Rename data sets
fullMeasurementsdt<-xdt
averageMeasurementsdt<-avgdt