####    AmazingFijiFunctions    ####

## Copyright (C) 2018  Kuhlemeier-Lab
## License GPL-3 | File LICENSE

pack<-installed.packages()
if(any(pack[,1]=="tidyr")==FALSE){
  install.packages("tidyr")
  
}

gettable<-function(getcolumn="Length", scale , columns ,
                   output = "" # if specified, saves the table in "<output>.csv"
                   ) {
  library(tidyr)
  setoffiles<-list.files(pattern = "*.csv")
  # trim accidental spaces from output string
  output <- trimws(output, which = "both")
  # if output exists, check no file with same name is in the folder
  if ((nchar(output) > 0) &
      (paste0(output, ".csv") %in% setoffiles)) {
    stop(paste0("'", output, ".csv' file already exists in this folder. Specify a different name for output file"))
    }
  nbfiles<-length(setoffiles)   ## will be used to open all files one after the other
  bigtable<-NULL                ## used at the end to build the table
  longlines<-0    ## used to stop the script after the checking phase
  willstop<-0
  for (i in 1:nbfiles){         ## Check the data, code for removing the annoying rows and warn
    workfile<-read.csv(setoffiles[i],header=TRUE,na.strings = "")
    workrow<-nrow(workfile)
    refcol<-is.na(workfile$Label)==FALSE&workfile$Label!="scale"&workfile$Label!="ND"  ## logical vector saying if each row of the "Label" column is something else than a blank, ND or the scale
    scalecol<-workfile$Label=="scale"    ## logical saying which positions of the "Label" column is the scale
    mtx<-matrix(data=c(refcol,scalecol),nrow = workrow) ##matrix of two columns that aligns refcol and scalecol
    line1<-c(which(mtx[,1]),length(mtx[,1])+1)  ## position of TRUE in refcol
    line2<-which(mtx[,2])     ###position of TRUE in scalecol
    if (scale==TRUE){
      stop("Wrong argument, scale cannot be TRUE.")
    } else if(scale==FALSE&sum(mtx[,2],na.rm = TRUE)>0){
      line2string<-toString(line2)
      stop("Data has one or several scale rows in file : ",setoffiles[i],", rows number: ",line2string)
    }
    line2<-c(line2,length(mtx[,2])+1)
    for (j in 1:(length(line1)-1)){
      if ((line1[j+1]-line1[j]-sum(line2<line1[j+1]&line2>line1[j]))!=length(columns)){
        warning("Unfitted data for gettable() function : ",setoffiles[i]," doesn't have ", length(columns), " values between rows ", line1[j], " and ",line1[j+1],".")
        willstop<-1
      }
    }
  }
  if (willstop==1){
    stop("Correct the data to fit the function.")
  }
  truescale<-1
  tablebase<-NULL
  for (i in 1:nbfiles){
    workfile<-read.csv(setoffiles[i],header=TRUE,na.strings = "")
    workrow<-nrow(workfile)
    refrow<-as.character(workfile$Label)
    filerow<-as.character(workfile$File)
    ## Manages the date format to make it understandable to R
    dateformat<-data.frame(rawdate=workfile$Date.Modif)
    daterow<-as.character(dateformat$rawdate)
    daterow[is.na(daterow)]<-0
    concat<-subset(dateformat,dateformat[,1]!=0)
    concat<-separate(concat, rawdate, c("week","b","d","time","CEST","Y"),sep=" " )
    concat<-data.frame(paste(concat$b,concat$d,concat$Y))
    daterow[daterow[]!=0]<-as.character(as.Date(concat[,1],"%b %d %Y"))
    processrow<-workfile[getcolumn]
    for (j in 1:workrow){
      if (is.na(refrow[j])){
        tablebase<-c(tablebase,format(processrow[j,1]*truescale,digits=2,nsmall=2))
      } else if (is.na(refrow[j])==FALSE&refrow[j]!="scale"&refrow[j]!="ND"){
        tablebase<-c(tablebase,filerow[j])
        tablebase<-c(tablebase,daterow[j])
        tablebase<-c(tablebase,refrow[j])
        tablebase<-c(tablebase,format(processrow[j,1]*truescale,digits=2,nsmall=2))
      } else if (refrow[j]=="ND"){
        tablebase<-c(tablebase,NA)
      } else if (refrow[j]=="scale"&scale!=FALSE){
        pixelscale<-processrow[j,1]
        truescale<-scale/pixelscale
      }
    }
  }
  lastcol<-length(columns)+3
  allcolumns<-c("file","date","name",columns)
  allcolumns<-factor(allcolumns,levels = unique (allcolumns)) ## turns characters into levelled factors to keep them in the right order when using split()
  pre_df<-split(tablebase,allcolumns) ##splits the data into different columns
  for (k in 4:lastcol){
    pre_df[[k]]<-as.numeric(pre_df[[k]])
  }
  bigtable<-data.frame(pre_df)
  bigtable[,1]<-as.character(bigtable[,1])
  bigtable[,2]<-as.Date(bigtable[,2])
  bigtable[,3]<-as.character(bigtable[,3])
  # save to .csv if requested
  if (nchar(output) > 0) {
    output <- paste0(output, ".csv")
    write.csv(bigtable, file = output, row.names = F)
    } else { bigtable }
}