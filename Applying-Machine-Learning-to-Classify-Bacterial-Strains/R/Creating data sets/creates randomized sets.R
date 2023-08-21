# Needed libraries
library(flowCore)
library(dplyr) 
# to check the accuracy this is needed.
# here we use the remaining data of the training sets to create datasets with 10k Bacteria
# in each set we have a different amount of BS and EColi. If you want to know how much the FL channels differ in comparison to the classified use data with FL in them and delete them late on
# to delete the FL channels use Deleting_FL-Channels.R

# Don't use any dots (.) in the FACS file names!!(It will express E.coli just as E)
# Which data (folder) to read?(R uses / instead of Windows \ !)  e.g. "E:/BA/V2/EX2 Cocultures/Raw_data
# to replace all press strg + f mark the line, klick In selection and put \ into Find and / into Replace
this <- "machine learning/comp_datasets/training/Without_FL/U/t24"
pfiles <- list.files(path= this,pattern=".csv$")
# set working directory to the place where your data is
setwd(this)

# Use pfiles to see the order of the files.
pfiles

# Where should be the data saved? The Folder will be created. e.g. E:/BA/V2/EX2 Cocultures/Comp_data/Cocultures_Training_Comp/ 
# no / at the end is needed it will be added with the number of the replicate at the end (Line 126)
Folder      <- "BA/machine learning/accuracy/without_FL/U/t24"   #e.g. C:/User/Documents/Compensated_data/
# A = first file, B = Second file -> A goes from 100 to 0,  B from 0 to 100
# To change names from mKate and GFP to GFP press Ctrl + f, Find mKate/GFP and Replace with UNL
Filename1   <- "BSUNL100_Ecoli_UNL0"           #For 0% A; 100% B                   
Filename2   <- "BSUNL90_Ecoli_UNL10"           #For 90% A; 10% B                            #e.g BSUNL_Ecoli_ #%            
Filename3   <- "BSUNL80_Ecoli_UNL20"           #For 80% A; 20% B
Filename4   <- "BSUNL70_Ecoli_UNL30"           #For 70% A; 30% B
Filename5   <- "BSUNL60_Ecoli_UNL40"           #For 60% A; 40% B
Filename6   <- "BSUNL50_Ecoli_UNL50"           #For 50% A; 50% B
Filename7   <- "BSUNL40_Ecoli_UNL60"           #For 40% A; 60% B
Filename8   <- "BSUNL30_Ecoli_UNL70"           #For 30% A; 70% B
Filename9   <- "BSUNL20_Ecoli_UNL80"           #For 20% A; 80% B
Filename10  <- "BSUNL10_Ecoli_UNL90"           #For 10% A; 90% B
Filename11  <- "BSUNL0_Ecoli_UNL100"           #For 100% A; 0% B
Ending      <- "without_FL2_FL5"                              #e.g without-FL2-FL5
suffix <- ".csv" # Changed if needed
nr <- 5    # number of replicates u want
# creates the Folder if it doesnt exist 
dir.create(paste(Folder,"/", sep="",collapse = NULL, recycle0 = FALSE ))
# Creates data frames with the unused data from the training sets
CSVs <- lapply(pfiles, read.csv)
# loop to create n amounts of random replicates to test the accuracy
for (i in 1:nr){
A <- CSVs[[1]]
B <- CSVs[[2]]
A <- A[30001:50000,]
B <- B[30001:50000,]

# Takes n random samples out of the 2 Bacteria samples with the n amount

# 100% A
A1 <- A %>% slice_sample(n = 10000, replace = FALSE)
dataset1 <- rbind(A1)
dataset1 <- na.omit(dataset1)
df1 <- data.frame(dataset1)

# 90% A, 10% B
A2 <- A %>% slice_sample(n = 9000, replace = FALSE)
B2 <- B %>% slice_sample(n = 1000, replace = FALSE)
dataset2 <- rbind(A2,B2)
dataset2 <- na.omit(dataset2)
df2 <- data.frame(dataset2)

# 80% A, 20% B
A3 <- A %>% slice_sample(n = 8000, replace = FALSE)
B3 <- B %>% slice_sample(n = 2000, replace = FALSE)
dataset3 <- rbind(A3,B3)
dataset3 <- na.omit(dataset3)
df3 <- data.frame(dataset3)

# 70% A, 30% B
A4 <- A %>% slice_sample(n = 7000, replace = FALSE)
B4 <- B %>% slice_sample(n = 3000, replace = FALSE)
dataset4 <- rbind(A4,B4)
dataset4 <- na.omit(dataset4)
df4 <- data.frame(dataset4)

# 60% A, 40% B
A5 <- A %>% slice_sample(n = 6000, replace = FALSE)
B5 <- B %>% slice_sample(n = 4000, replace = FALSE)
dataset5 <- rbind(A5,B5)
dataset5 <- na.omit(dataset5)
df5 <- data.frame(dataset5)

# 50% A, 50% B
A6 <- A %>% slice_sample(n = 5000, replace = FALSE)
B6 <- B %>% slice_sample(n = 5000, replace = FALSE)
dataset6 <- rbind(A6,B6)
dataset6 <- na.omit(dataset6)
df6 <- data.frame(dataset6)

# 40% A, 60% B
A7 <- A %>% slice_sample(n = 4000, replace = FALSE)
B7 <- B %>% slice_sample(n = 6000, replace = FALSE)
dataset7 <- rbind(A7,B7)
dataset7 <- na.omit(dataset7)
df7 <- data.frame(dataset7)

# 30% A, 70% B
A8 <- A %>% slice_sample(n = 3000, replace = FALSE)
B8 <- B %>% slice_sample(n = 7000, replace = FALSE)
dataset8 <- rbind(A8,B8)
dataset8 <- na.omit(dataset8)
df8 <- data.frame(dataset8)

# 20% A, 80% B
A9 <- A %>% slice_sample(n = 2000, replace = FALSE)
B9 <- B %>% slice_sample(n = 8000, replace = FALSE)
dataset9 <- rbind(A9,B9)
dataset9 <- na.omit(dataset9)
df9 <- data.frame(dataset9)

# 10% A, 90% B
A10 <- A %>% slice_sample(n = 1000, replace = FALSE)
B10 <- B %>% slice_sample(n = 9000, replace = FALSE)
dataset10 <- rbind(A10,B10)
dataset10 <- na.omit(dataset10)
df10 <- data.frame(dataset10)

# 100% B
B11 <- B %>% slice_sample(n = 10000, replace = FALSE)
dataset11 <- rbind(B11)
dataset11 <- na.omit(dataset11)
df11 <- data.frame(dataset11)

# Write the Data into a csv file
# Folderc = Folder/replicate/ i / 
Folderc <- paste(Folder,"/","replicate", i, "/", sep="",collapse = NULL, recycle0 = FALSE )
# Creates Folderc
dir.create(paste(Folderc, sep="",collapse = NULL, recycle0 = FALSE ))
# sets the working directory into Folderc
setwd(paste(Folderc))
# writes all the replicates 
write.csv(df1,paste(Folderc,Filename1,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ) ,row.names = FALSE)
write.csv(df2,paste(Folderc,Filename2,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df3,paste(Folderc,Filename3,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df4,paste(Folderc,Filename4,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df5,paste(Folderc,Filename5,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df6,paste(Folderc,Filename6,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df7,paste(Folderc,Filename7,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df8,paste(Folderc,Filename8,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df9,paste(Folderc,Filename9,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df10,paste(Folderc,Filename10,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
write.csv(df11,paste(Folderc,Filename11,Ending, suffix, sep="",collapse = NULL, recycle0 = FALSE ), row.names = FALSE)
}
# removes all item in the environment to save ram space
rm(list = ls())
print("DONE")