gettable<-function(getcolumn="Length", scale = 2, columns ) {
  setoffiles<-list.files()
  nbfiles<-length(setoffiles)
  bigtable<-NULL
  longlines<-NULL
  for (i in 1:nbfiles){
    workfile<-read.csv(setoffiles[i],header=TRUE,na.strings = "")
    workrow<-nrow(workfile)
    refcol<-is.na(workfile$Label)==FALSE&workfile$Label!="scale"&workfile$Label!="ND"
    scalecol<-workfile$Label=="scale"
    mtx<-matrix(data=c(refcol,scalecol),nrow = workrow)
    line1<-c(which(mtx[,1]),length(mtx[,1])+1)
    line2<-which(mtx[,2])
    if(scale==FALSE&sum(mtx[,2],na.rm = TRUE)>0){
      scalemtx<-matrix(c(line2,rep(" ",times=length(line2))),ncol = length(line2),byrow = TRUE)
      stop("Data has one or several scale rows in file : ",setoffiles[i],", rows number: ",scalemtx)
    }
    line2<-c(line2,length(mtx[,2])+1)
    for (j in 1:(length(line1)-1)){
      line1<<-line1
      line2<<-line2
      if ((line1[j+1]-line1[j]-sum(line2<line1[j+1]&line2>line1[j]))!=length(columns)-1){
        stop("Data not fitted for gettable() function : ",setoffiles[i]," doesn't have ", length(columns)-1, " values between rows ", line1[j], " and ",line1[j+1],".")
      }
    }
  }
  if (scale==FALSE){
    truescale<-1
  }
  for (i in 1:nbfiles){
    workfile<-read.csv(setoffiles[i],header=TRUE,na.strings = "")
    workrow<-nrow(workfile)
    refrow<-as.character(workfile$Label)
    processrow<-workfile[getcolumn]
    tablebase<-as.character(NULL)
    for (j in 1:workrow){
      if (is.na(refrow[j])){
        tablebase<-c(tablebase,format(processrow[j,1]*truescale,digits=2,nsmall=2))
      } else if (is.na(refrow[j])==FALSE&refrow[j]!="scale"&refrow[j]!="ND"){
        tablebase<-c(tablebase,refrow[j])
        tablebase<-c(tablebase,format(processrow[j,1]*truescale,digits=2,nsmall=2))
      } else if (refrow[j]=="ND"){
        tablebase<-c(tablebase,NA)
      } else if (refrow[j]=="scale"&scale!=FALSE){
        pixelscale<-processrow[j,1]
        truescale<-scale/pixelscale
      }
    }
    longlines<-c(longlines,tablebase)
  }
  bigtable<-matrix(data=longlines,byrow = TRUE, ncol = length(columns))
  colnames(bigtable)<-columns
  bigtable<-as.data.frame(bigtable)
  bigtable[,1]<-as.character(bigtable[,1])
  bigtable
}
