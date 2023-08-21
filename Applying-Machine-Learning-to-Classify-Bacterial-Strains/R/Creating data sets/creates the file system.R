#to create all the directories the way i did
#where
here = "" #e.g. E:/BA/project

#rest is automated
ml = paste(here,"/machine learning",sep = "")

fraw = paste(ml,"/raw_datasets",sep ="")
dir.create(fraw,recursive = TRUE)

#training with FL
comp = paste(ml,"/comp_datasets/", sep = "")
train = paste(comp, "/training/", sep = "")
dir.create(paste(train, "/With_FL/t0",sep =""),recursive = TRUE)
dir.create(paste(train, "/With_FL/t8",sep =""),recursive = TRUE)
dir.create(paste(train, "/With_FL/t24",sep =""),recursive = TRUE)


#training with out FL
wol = paste(train,"/Without_FL/L" , sep = "")
dir.create(paste(wol,"/t0",sep =""),recursive = TRUE)
dir.create(paste(wol,"/t8",sep =""),recursive = TRUE)
dir.create(paste(wol,"/t24",sep =""),recursive = TRUE)

wou =paste(train,"/Without_FL/U" , sep = "")
dir.create(paste(wou,"/t0",sep =""),recursive = TRUE)
dir.create(paste(wou,"/t8",sep =""),recursive = TRUE)
dir.create(paste(wou,"/t24",sep =""),recursive = TRUE)

#test 
#t0
dir.create(paste(comp,"/t0/L",sep =""),recursive = TRUE)
dir.create(paste(comp,"/t0/U",sep =""),recursive = TRUE)


#t8
dir.create(paste(comp,"/t8/L",sep =""),recursive = TRUE)
dir.create(paste(comp,"/t8/U",sep =""),recursive = TRUE)


#t24
dir.create(paste(comp,"/t24/L",sep =""),recursive = TRUE)
dir.create(paste(comp,"/t24/U",sep =""),recursive = TRUE)

#accuracy
acc= paste(ml,"/accuracy", sep = "")
#w L
accwL = paste(acc,"/with_FL/L", sep = "")
dir.create(paste(accwL,"/t0",sep =""),recursive = TRUE)
dir.create(paste(accwL,"/t8",sep =""),recursive = TRUE)
dir.create(paste(accwL,"/t24",sep =""),recursive = TRUE)

#wo L
accwoL = paste(acc,"/without_FL/L", sep = "")
dir.create(paste(accwoL,"/t0",sep =""),recursive = TRUE)
dir.create(paste(accwoL,"/t8",sep =""),recursive = TRUE)
dir.create(paste(accwoL,"/t24",sep =""),recursive = TRUE)
#wo U
accwoU = paste(acc,"/without_FL/U", sep = "")
dir.create(paste(accwoU,"/t0",sep =""),recursive = TRUE)
dir.create(paste(accwoU,"/t8",sep =""),recursive = TRUE)
dir.create(paste(accwoU,"/t24",sep =""),recursive = TRUE)

#Julia
dir.create(paste(ml,"/Julia",sep =""),recursive = TRUE)
#R
dir.create(paste(ml,"/R",sep =""),recursive = TRUE)
#Results
dir.create(paste(ml,"/Results",sep =""),recursive = TRUE)
print("Done")
