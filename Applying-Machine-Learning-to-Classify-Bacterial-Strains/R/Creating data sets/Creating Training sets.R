# Needed libraries
#installation needed once per R studio project
if (!require("BiocManager", quietly = TRUE))
install.packages("BiocManager")
BiocManager::install("flowCore")

# Activation needed once per R studio session
library(ggcyto)
library(flowCore)
library(flowAI)


# Insert up 14 Training samples to get up to 14 Training sets and one with the first 30k Data points out of the single Data frames

# Don't use any dots (.) in the FACS file names!!(It will express E.coli just as E)
# Which data (folder) to read?(R uses / instead of Windows \ !)  e.g. "E:/BA/V2/EX2 Cocultures/Raw_data
# to replace all press Ctrl + f mark the line, klick In selection and put \ into Find and / into Replace
this <- "/machine learning/raw_datasets/Cocultures_Training_FACS/all_Train"       #e.g. C:/User/Documents/FACS_files
myfiles <- list.files(path= this, pattern=".fcs$")

# sets working directory to the place where your uncompensated data is. 
setwd(this)

# use myfiles to see the order of your files
myfiles


# Where should be the data saved? The Folder will be created. 
# eg. E:/BA/machine learning/comp_datasets/training/With_FL/ 
# ( / at the end is needed!)
Folder      <- "/machine learning/comp_datasets/training/With_FL/"   
# Name all the files you want, leave names empty you don't need
Filename1   <- "BSmKate_t0"            
Filename2   <- "BSmKate_t24"
Filename3   <- "BSmKate_t8"
Filename4   <- "BSUNL_t0"
Filename5   <- "BSUNL2_t24"
Filename6   <- "BSUNL_t8"
Filename7   <- "ECGFP_t0"
Filename8   <- "ECGFP_t24"
Filename9   <- "ECGFP_t8"
Filename10  <- "ECUNL_t0"
Filename11  <- "ECUNL_t24"
Filename12  <- "ECUNL_t8"
Filename13  <- ""
Filename14  <- ""
TrainingSet <- "Training_all" #All training sets together
Ending      <- "_with_FL2_FL5"
suffix <- ".csv" # Expresses as .csv frame
n           <- length(myfiles)#number of files

# Names of the Bactria #e.g Bacillus
Bac1  <-  "BS"         # 1
Bac2  <-  "BS"         # 2
Bac3  <-  "BS"         # 3
Bac4  <-  "BS"         # 4
Bac5  <-  "BS"           # 5
Bac6  <-  "BS"           # 6
Bac7  <-  "EC"           # 7
Bac8  <-  "EC"           # 8
Bac9  <-  "EC"           # 9
Bac10 <-  "EC"           # 10
Bac11 <-  "EC"           # 11
Bac12 <-  "EC"           # 12
Bac13 <-  ""           # 13
Bac14 <-  ""           # 14


# Select up to 10 FL ,Leave empty what you don't need. (e.g BS and Ecoli FL2.A... and FL5.A...)
# the names have to be changed if there is a "." in it. it will be changed into "_" (L107)
FL_channel1     <- ""
FL_channel2     <- ""
FL_channel3     <- ""
FL_channel4     <- ""
FL_channel5     <- ""
FL_channel6     <- ""
FL_channel7     <- ""
FL_channel8     <- ""
FL_channel9     <- ""
FL_channel10    <- ""
#______now the compensation and binding into usable training files starts_____
# Read the files you want to compensate
fs <- flowCore::read.flowSet(myfiles, path= this)
# Shows the spillover matrix of the first file 
# spillover(fs[[1]])

# Apply spillover
fs_comp <- fsApply(fs,function(frame){
  #extract compensation matrix from keywords
  comp <- keyword(frame)$`SPILL`
  new_frame <- compensate(frame,comp)
  new_frame
})
# Clean all the false data, set fcs_highQ = true to get the .fcs file with the high quality compensated data
# this sometimes fails so you need to test if this works for all your files befor you use this
# if it fails for one file just leave it out
#fs_comp_clean <- flow_auto_qc(
#  fs_comp,
#  html_report = FALSE,
#  mini_report = FALSE,
#  fcs_highQ = FALSE,
#  fcs_QC =FALSE,
#  folder_results = FALSE,
# second_fractionFR = 1)

# Creates a function to clean the column names 
colClean <- function(x){ colnames(x) <- gsub("\\.", "_", colnames(x)); x } # Creates a function to replace all . with _. Julia doesn't like . in names
#                                                                           care if this says "//." change it back to "\\."!
# creates a function to delete the Fl. channels selected
delFL <- function(x) x[!(names(x) %in% c(FL_channel1, FL_channel2, FL_channel3, FL_channel4, FL_channel5, FL_channel6, FL_channel7, FL_channel8, FL_channel9, FL_channel10))]

# needed for the following function
# binds the file names 
Filename <- c(Filename1, Filename2,Filename3,Filename4,Filename5,Filename6,Filename7,Filename8,Filename9,Filename10,Filename11,Filename12,Filename13,Filename14)    
# binds the Bac. names
Bac <- c(Bac1,Bac2,Bac3,Bac4,Bac5,Bac6,Bac7,Bac8,Bac9,Bac10,Bac11,Bac12,Bac13,Bac14)

# creates the function to clean insert all the names, delete unnecessary columns and write the files with the correct name
DF <- function(x,i){ 
  for (i in 1:n){
    A<- x[[i]]; # defines the selected file (Number i) as A
    A <- exprs(A); # expresses A ( from large flow frame -> large matrix)
    A <-  as.data.frame(A);# changes A into A data frame
    LA <- length(A[[i]]); # counts the length of the first row of A, used in the next line to copy the bacteria name in each row
    name <-rep(Bac[i], (paste(LA))); # creates a list of bacteria name in the length of the data frame
    A <- cbind(A, name); # binds the names to the data frame
    A <- A[,-c(1)]; # removes the first(time) column from the data frame, remove this if the first row is not an unnecessary column 
    A <- delFL(A) # deletes the selected FL channels
    A <- colClean (A); # changes . in the column names to _ , in Julia . ends the action and cant be used
    # writes an csv file with the name defined above
    write.csv(A,paste(Folder,paste(Filename[i]),Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
    }
}
# Creates the save Folder if it doesn't exist
dir.create(Folder)
# applys the function above to the files 
try(DF(fs_comp), silent = TRUE)

#Creating one big Training set

setwd(Folder)
# reads the files in the selected folder with the endind .csv
myfilesTrain <-list.files(path= Folder, pattern = ".csv")
CSVsTrain <- lapply(myfilesTrain, read.csv)

# creates workable data frames in r           
try(dfTrain1 <- CSVsTrain[[1]], silent = TRUE)
try(dfTrain2 <- CSVsTrain[[2]], silent = TRUE)
try(dfTrain3 <- CSVsTrain[[3]], silent = TRUE)
try(dfTrain4 <- CSVsTrain[[4]], silent = TRUE)
try(dfTrain5 <- CSVsTrain[[5]], silent = TRUE)
try(dfTrain6 <- CSVsTrain[[6]], silent = TRUE)
try(dfTrain7 <- CSVsTrain[[7]], silent = TRUE)
try(dfTrain8 <- CSVsTrain[[8]], silent = TRUE)
try(dfTrain9 <- CSVsTrain[[9]], silent = TRUE)
try(dfTrain10 <- CSVsTrain[[10]], silent = TRUE)
try(dfTrain11 <- CSVsTrain[[11]], silent = TRUE)
try(dfTrain12 <- CSVsTrain[[12]], silent = TRUE)
try(dfTrain13 <- CSVsTrain[[13]], silent = TRUE)
try(dfTrain14 <- CSVsTrain[[14]], silent = TRUE)


# Checking if the number of files is in between 2 and 14
if (n <2){
stop(paste("not enough Files in",Folder))
}

if (n >14){
  stop(paste("to many Files in",Folder))
}
# binds the Training sets into one big set possible 
if (n == 14){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,],dfTrain7[1:30000,],dfTrain8[1:30000,],dfTrain9[1:30000,],dfTrain10[1:30000,],dfTrain11[1:30000,],dfTrain12[1:30000,],dfTrain13[1:30000,],dfTrain14[1:30000,])
}
if (n == 13){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,],dfTrain7[1:30000,],dfTrain8[1:30000,],dfTrain9[1:30000,],dfTrain10[1:30000,],dfTrain11[1:30000,],dfTrain12[1:30000,],dfTrain13[1:30000,])
}
if (n == 12){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,],dfTrain7[1:30000,],dfTrain8[1:30000,],dfTrain9[1:30000,],dfTrain10[1:30000,],dfTrain11[1:30000,],dfTrain12[1:30000,]) 
}
if (n == 11){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,],dfTrain7[1:30000,],dfTrain8[1:30000,],dfTrain9[1:30000,],dfTrain10[1:30000,],dfTrain11[1:30000,])
}
if (n == 10){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,],dfTrain7[1:30000,],dfTrain8[1:30000,],dfTrain9[1:30000,],dfTrain10[1:30000,])
}
if (n == 9){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,],dfTrain7[1:30000,],dfTrain8[1:30000,],dfTrain9[1:30000,])  
}
if (n == 8){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,],dfTrain7[1:30000,],dfTrain8[1:30000,])
}
if (n == 7){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,],dfTrain7[1:30000,])
}
if (n == 6){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,],dfTrain6[1:30000,])
}
if (n == 5){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,],dfTrain5[1:30000,])
}
if (n == 4){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,],dfTrain4[1:30000,])
}
if (n == 3){
  dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,],dfTrain3[1:30000,])
}
if (n == 2){
dfallTrain <- rbind(dfTrain1[1:30000,], dfTrain2[1:30000,])
}
#  the combined Training file into Files
try(write.csv(dfallTrain,paste(Folder,TrainingSet,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE), silent = TRUE)
# removes all item in the environment to save ram space
# removes all item in the environment to save ram space
rm(list = ls())
print("DONE")
 