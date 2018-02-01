gettable<-function(getcolumn="Length", scale = 2, columns ) {
  setoffiles<-list.files()
  nbfiles<-length(setoffiles)
  bigtable<-NULL
  longlines<-NULL
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
