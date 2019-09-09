library(tidyverse)

args =commandArgs(trailingOnly=T)


#read in the csv of accrediated institutions
institutions_df<-read_csv(args[1])

for(i in 1:nrow(institutions_df)){
  if(institutions_df[i,4]=="-"){
    institutions_df[i,4]=institutions_df[i,3]
  } else {
    institutions_df[i,4]=institutions_df[i,4]
  }
}

#Make a unique list of accredited US institutions for matching and add an "exist" variable to track real institutions when merging

institutions_match<-institutions_df[,4]%>%mutate(exist="Yes")%>%unique() 


#write a csv of joined data
write.csv(institutions_match,file="institutions2.csv",row.names=F)