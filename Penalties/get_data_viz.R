#load libraries
library(dplyr)
library(plyr)
library(magrittr)
library(ggplot2)

#get data
penls <- ""
for (i in 20001:21230) {
  preload <- load(paste("C:\\Users\\Ingrid\\Downloads\\nhlr-data\\20152016-",i,"-processed.RData",sep=""))
  game <- get(preload)
  game <- game$playbyplay[game$playbyplay$etype == 'PENL',]
  penl <- subset(game, select = -c(refdate,event,a1,a2,a3,a4,a5,a6,h1,h2,h3,h4,h5,h6,distance,xcoord,ycoord,event.length))
  ##shots <- subset(allshots,etype!="MISS")
  penls <- rbind(penls,penl)
}

#remove any served by
penls$type <- ifelse(grepl(' Served',penls$type),substr(penls$type,1,regexpr(" Served By",penls$type)[1]-1),penls$type)
#remove major/double minor
penls$type <- gsub(' \\(maj\\)| double minor','',penls$type)
#split into type and duration
penls$duration <- sapply(penls$type, function(x) substr(x,regexpr("\\(",x)[1],regexpr("\\)",x)[1]) %>% gsub('\\(|\\)| min','',.) %>% as.numeric(.))
penls$type <- sapply(penls$type, function(x) substr(x,1,regexpr("\\(",x)[1]-1))
#remove NAs
penls <- penls[!is.na(penls$duration), ]
