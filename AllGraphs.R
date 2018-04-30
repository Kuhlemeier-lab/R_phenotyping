pack<-installed.packages()
if(any(pack[,1]=="ggplot2")==FALSE){
  install.packages("ggplot2")
}
rm(pack)
library(ggplot2)

allgraphs<-function(dataframe, foldername="AllGraphs", x, y,jitter=TRUE){
  if (dir.exists(foldername)){
    stop("folder AllGraphs already exist in current working directory. Use another name with foldername.")
    }
  else if (length(x)>2){
    stop("argument x length cannot be superior to 2")
    }
  else if (jitter!=TRUE&jitter!=FALSE){
    stop("argument jitter must be TRUE or FALSE")
    }
  basewd<-getwd()
  dir.create(foldername)
  setwd(foldername)
  colcol<-colnames(dataframe[,y,drop=FALSE])
  abs<-colnames(dataframe[,x,drop=FALSE])
  if (length(x)==1){
    for (i in 1:length(colcol)){
      ord<-colcol[i]
      if (jitter==TRUE){
        ggplot(dataframe,
               aes_string(x=abs,y=ord,fill=abs))+
          geom_boxplot(outlier.size = 0,
                       outlier.alpha = 0)+
          geom_jitter(height=0,
                      width = 0.1)+
          ggtitle(ord,
                  subtitle= Sys.Date())
      }
      else if (jitter==FALSE){
        ggplot(dataframe,
               aes_string(x=abs,y=ord))+
          geom_boxplot()+
          ggtitle(ord,
                  subtitle= Sys.Date())
      }
      ggsave(paste(ord,".png",sep = ""))
    }
  }
  else if (length(x)==2){
    for (i in 1:length(colcol)){
      ord<-colcol[i]
      if (jitter==TRUE){
        ggplot(dataframe,
               aes_string(x=abs[1],y=ord,fill=abs[2]))+
          geom_boxplot(outlier.size = 0,
                       outlier.alpha = 0)+
          geom_jitter(position = position_dodge(width=0.75))+
          ggtitle(ord,
                  subtitle= Sys.Date())
      }
      else if (jitter==FALSE){
        ggplot(dataframe,
               aes_string(x=abs,y=ord,fill=abs[2]))+
          geom_boxplot()+
          ggtitle(ord,
                  subtitle= Sys.Date())
      }
      ggsave(paste(ord,".png",sep = ""))
    }
  }
  setwd(basewd)
}
