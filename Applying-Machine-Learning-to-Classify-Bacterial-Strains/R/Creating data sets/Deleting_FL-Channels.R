# Needed libraries
library(flowCore)
library(flowAI)
library(ggcyto)

# Insert up 14 Test samples to get up to 14 Test set


# Don't use any dots (.) in the FACS file names!!(It will express E.coli just as E)
# Which data (folder) to read?(R uses / instead of Windows \ !)  e.g. "E:/BA/V2/EX2 Cocultures/Raw_data
# to replace all press ctrl + f mark the line, klick In selection and put \ into Find and / into Replace
# leave out the replicate folder at the end, it will be added later
this <- "/machine learning/accuracy/with_FL/L/t0"

# adds the replicate folder, this is just use to see the order of files
this1 <- paste(this,"/replicate1/", sep="",collapse = NULL, recycle0 = FALSE )
myfiles <-list.files(path= this1, pattern = ".csv")
# Order of files
myfiles

# Where should be the data saved? The Folder will be created. e.g. E:/BA/V2/EX2 Cocultures/Comp_data/Cocultures_Training_Comp/ 
# ( / at the end is needed!)
Folder      <- "/machine learning/accuracy/without_FL/L/t0"   #e.g Bacillus_mKate
# To use the same names for the files, dubble klick on the name in the Console
# to mark them ,ctrl + c to copy and paste them into to the according Filename row
Filename1   <- "BSmKate0_Ecoli_GFP100"            
Filename2   <- "BSmKate10_Ecoli_GFP90"
Filename3   <- "BSmKate100_Ecoli_GFP0"
Filename4   <- "BSmKate20_Ecoli_GFP80"
Filename5   <- "BSmKate30_Ecoli_GFP70"
Filename6   <- "BSmKate40_Ecoli_GFP60"
Filename7   <- "BSmKate50_Ecoli_GFP50"
Filename8   <- "BSmKate60_Ecoli_GFP40"
Filename9   <- "BSmKate70_Ecoli_GFP30"
Filename10  <- "BSmKate80_Ecoli_GFP20"
Filename11  <- "BSmKate90_Ecoli_GFP10"
Filename12  <- ""
Filename13  <- ""
Filename14  <- ""
Ending      <- "_without_FL2_FL5"
suffix <- ".csv" # Expresses as .csv frame
# Select up to 10 FL ,Leave empty that you dont need. (e.g BS and Ecoli FL2 and FL5)
FL_channel1     <- "FL2_A"
FL_channel2     <- "FL2_H"
FL_channel3     <- "FL2_W"
FL_channel4     <- "FL5_A"
FL_channel5     <- "FL5_H"
FL_channel6     <- "FL5_W"
FL_channel7     <- ""
FL_channel8     <- ""
FL_channel9     <- ""
FL_channel10    <- ""

# binds the file names 
Filename <- c(Filename1, Filename2,Filename3,Filename4,Filename5,Filename6,Filename7,Filename8,Filename9,Filename10,Filename11,Filename12,Filename13,Filename14)    
n <- length(myfiles) 
# deletes the selected channels
delFL <- function(x) x[!(names(x) %in% c(FL_channel1, FL_channel2, FL_channel3, FL_channel4, FL_channel5, FL_channel6, FL_channel7, FL_channel8, FL_channel9, FL_channel10))]

# creates a lists of all replicate folders 
folderlist <-list.files(path= this, pattern = "replicate")
# count of all replicate folders 
nf <- length(folderlist)
# reads in each replicate folder and writes it to correct new Folder 
for (i in 1:nf){
setwd(paste(this,folderlist[i],"/", sep="/",collapse = NULL, recycle0 = FALSE )) #sets the working directory into this/replicatei
fs <- list.files(path= paste(this,folderlist[i],"/", sep="/",collapse = NULL, recycle0 = FALSE ), pattern = ".csv")# creates a list of all files in this/replicatei
fs <- lapply(fs, read.csv) # reads all the csv files in this/replicatei
dir.create(paste(Folder,folderlist[i],"/", sep="/",collapse = NULL, recycle0 = FALSE ),recursive = TRUE) # creates the new save folder
setwd(paste(Folder,folderlist[i],"/", sep="/",collapse = NULL, recycle0 = FALSE ))#sets the working directory into Folder/folderlist[i]/replicatei
for (j in 1:n){
    df1 <- delFL(fs[[j]]) #delets the FL channels
    write.csv(df1,paste(Folder,folderlist[i],paste(Filename[j],Ending,suffix, sep="",collapse = NULL, recycle0 = FALSE ), sep="/",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
    # writes the csv files
  }
}
# removes the list to save RAM and 
rm(list = ls())
print("DONE")
