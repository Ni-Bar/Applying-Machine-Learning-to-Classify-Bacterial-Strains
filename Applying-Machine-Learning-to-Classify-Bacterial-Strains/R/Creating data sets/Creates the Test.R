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
this <- "/machine learning/raw_datasets/Cocultures t24 FACS/U"       #e.g. C:/User/Documents/FACS_files
myfiles <- list.files(path= this, pattern=".fcs$")
# sets working directory to the place where your uncompensated data is. 
setwd(this)
# use myfiles to see the order of your files
myfiles

# Where should be the data saved? The Folder will be created. e.g. E:/BA/V2/EX2 Cocultures/Comp_data/Cocultures_Training_Comp/ 
# ( / at the end is needed!)
Folder      <- "/machine learning/comp_datasets/t24/U/"   
# Name all the files you want, leave names empty you don't need
# if you want your compensated files named like the raw files leave line 44 active, else block it with #
#Filename1   <- "U1"            
#Filename2   <- "U2"
#Filename3   <- "U3"
#Filename4   <- "U4"
#Filename5   <- "U5"
#Filename6   <- "U6"
#Filename7   <- "U7"
#Filename8   <- ""
#Filename9   <- ""
#Filename10  <- ""
#Filename11  <- ""
#Filename12  <- ""
#Filename13  <- ""
#Filename14  <- ""
resultnames <- list.files(this,pattern = ".fcs") # takes the names of the files to use it as 
Ending      <- "_wo_FL2_FL5"
suffix <- ".csv" # Expresses as .csv frame
n           <- length(myfiles)#number of files

# Select up to 10 FL, leave empty that you don't need. (e.g BS and Ecoli FL2 A/H and FL5 A/H)
FL_channel1     <- "FL2.A"
FL_channel2     <- "FL2.H"
FL_channel3     <- "FL2.W"
FL_channel4     <- "FL5.A"
FL_channel5     <- "FL5.H"
FL_channel6     <- "FL5.W"
FL_channel7     <- ""
FL_channel8     <- ""
FL_channel9     <- ""
FL_channel10    <- ""

# Name the Bacteria

Bac1  <-  "UNKNOWN"           # 1
Bac2  <-  "UNKNOWN"           # 2
Bac3  <-  "UNKNOWN"           # 3
Bac4  <-  "UNKNOWN"           # 4
Bac5  <-  "UNKNOWN"           # 5
Bac6  <-  "UNKNOWN"           # 6
Bac7  <-  "UNKNOWN"           # 7
Bac8  <-  "UNKNOWN"           # 8
Bac9  <-  "UNKNOWN"           # 9
Bac10 <-  "UNKNOWN"           # 10
Bac11 <-  "UNKNOWN"           # 11
Bac12 <-  "UNKNOWN"           # 12
Bac13 <-  "UNKNOWN"           # 13
Bac14 <-  "UNKNOWN"           # 14
#______now the compensation and binding into usable training files starts_____

# Read the files you want to compensate
fs <- flowCore::read.flowSet(myfiles, path= this)
# Shows the spillover matrix of the first file 
# spillover(fs[[1]])

#Apply spillover
fs_comp <- fsApply(fs,function(frame){
  #extract compensation matrix from keywords
  comp <- keyword(frame)$`SPILL`
  new_frame <- compensate(frame,comp)
  new_frame
})

# Clean all the false data, set fcs_highQ = true to get the .fcs file with the high quality compensated data
# this sometimes fails so you need to test if this works for all your files befor you use this
# if it fails for one file just leave it out
# fs_comp <- flow_auto_qc(
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
# if Filename1 exist use the file names, else use the raw file names
if (exists("Filename1") == TRUE){
  resultnames <- c(Filename1,Filename2,Filename3,Filename4,Filename5,Filename6,Filename7,Filename8,Filename9,Filename10,Filename11,Filename12,Filename13,Filename14)
} else{
  resultnames <- gsub(pattern = "\\.fcs",replacement = "",resultnames)
  print("No filenames found! raw filenames are used insted.")
}

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
    write.csv(A,paste(Folder,resultnames[i],Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
    }
}
# creates the Folder if it doesnt exist
dir.create(Folder)
# applys the function above to the files
df<- DF(fs_comp)
# removes all item in the environment to save ram space
rm(list = ls())
print("DONE")