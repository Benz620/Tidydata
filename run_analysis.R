## Loading the library for this project 
library(tidyverse)
library(data.table)
library(plyr)


## Creating the projecting directory 
if(!file.exists("./project")){
  dir.create("./project")
}


## The zipefile
fileZip<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

### the file was too heavy, I had to extend to  download timeout
### From 60 to 1000 second
options(timeout = max(1000,getOption("timeout")))


## Downloading the file 
download.file(fileZip, destfile = "./project/project.zip")

setwd("./project")

zipfile<-list.files(path = getwd(),pattern="*.zip",full.names = TRUE)
### ldply from the plyr package help me to directly specify 
### where can I found each file from the zipefile by returning
### a caracter vector for each of them
zipefilepath<-ldply(.data = zipfile,.fun = unzip,exdir=getwd())
# See it for yourself. It gives a path from each of the file
# from the zipefile
zipefilepath


## Reading the file
x_train<-read.table(zipefilepath$V27)
y_train<-read.table(zipefilepath$V28)
x_test <- read.table(zipefilepath$V15)
y_test <- read.table(zipefilepath$V16,sep=",")
subject_train<- read.table(zipefilepath$V26,sep=",")
subject_test <- read.table(zipefilepath$V14,sep=",")
features<-read.table(zipefilepath$V2)
activity<- read.table(zipefilepath$V1)

## Binding the data 
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject<- rbind(subject_train,subject_test)

#Renaming the column
colnames(subject)<- "subject ID"

colnames(features)<- c("features ID","  featuresname")
colnames(activity)<- c("activity ID","activity label")

colnames(x)<- features$`  featuresname`
colnames(y)<- "activity ID"

## Join works better than merge for me 
activity<- join(y,activity,by="activity ID")
# finally binding all the data
data <-cbind(subject,activity$`activity label`,x)
colnames(data)[colnames(data)=="activity$`activity label`"]<- "ACTIVITY"


### sub-setting the mean and standard deviation calculation and also 
### The first 2 column which contains the ID of each person
## and also the activity
data <- data[,c(1,2,grep("mean|std",colnames(data)))]

## Calculating the mean for for each activity and  subject 
data <- data.table(data)
data_mean_activity<-data[,lapply(.SD,mean),by=c("subject ID","ACTIVITY")]
View(data_mean_activity)
### saving the file 
write.table(data_mean_activity, file = "data.txt", sep=",",row.names = F,col.names=FALSE)


#######################################