####    AmazingFijiFunctions    ####

## Copyright (C) 2018  Kuhlemeier-Lab
## License GPL-3 | File LICENSE

gettable<-function(getcolumn="Length", scale , columns ) {
  setoffiles<-list.files()
  setoffiles<-setoffiles[grep(".csv",setoffiles)]
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
      if ((line1[j+1]-line1[j]-sum(line2<line1[j+1]&line2>line1[j]))!=length(columns)-1){
        warning("Unfitted data for gettable() function : ",setoffiles[i]," doesn't have ", length(columns)-1, " values between rows ", line1[j], " and ",line1[j+1],".")
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
    processrow<-workfile[getcolumn]
    for (j in 1:workrow){
      if (is.na(refrow[j])){
        tablebase<-c(tablebase,format(processrow[j,1]*truescale,digits=2,nsmall=2))
      } else if (is.na(refrow[j])==FALSE&refrow[j]!="scale"&refrow[j]!="ND"){
        tablebase<-c(tablebase,filerow[j])
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
  lastcol<-length(columns)+1
  allcolumns<-c("file",columns)
  allcolumns<-factor(allcolumns,levels = unique (allcolumns)) ## turns characters into levelled factors to keep them in the right order when using split()
  pre_df<-split(tablebase,allcolumns)##splits the data into different columns
  for (k in 3:lastcol){
    pre_df[[k]]<-as.numeric(pre_df[[k]])
  }
  bigtable<-data.frame(pre_df)
  bigtable[,1]<-as.character(bigtable[,1])
  bigtable[,2]<-as.character(bigtable[,2])
  bigtable
}