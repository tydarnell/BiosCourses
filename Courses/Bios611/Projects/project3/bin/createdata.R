library(tidyverse)

args =commandArgs(trailingOnly=T)

full_file <- readLines(args[1])
institutions_match <- read_csv(args[2])


abstracts_df<-tibble("Authors"=character(),"Abstract"=character()) 
#Create a tibble, will store author and abstract info


  for (j in 1:length(full_file)){
    if(substring(full_file[j],1,6)=="Author"){
      abstracts_df[i,1]=full_file[j]
      abstracts_df[i,2]=casefold(full_file[j+1])
    }
  }

#Create an empty tibble to store the split collaborator info
collab_df<-tibble("Collaborators"=character(),"Abstract"=character()) 


m=0
for (i in 1:nrow(abstracts_df)){
  Ident<-authors_df[i,1]
  author_split=strsplit(as.character(Ident),'\\(\\d+\\)')
  comma_split=strsplit(author_split[[1]],',')
  for (j in 1:length(unlist(comma_split))){
    collab_df[m+j,1]=unlist(comma_split)[j]
    collab_df[m+j,2]=authors_df[i,2]
  }
  m=m+length(unlist(comma_split))
}

#Trimming white space from institution names

collab_df<-data.frame(lapply(collab_df,trimws),stringsAsFactors=FALSE)

#Merge collab data with list of institutions

collab_match<-collab_df%>%
  left_join(institutions_match,by=c("Collaborators"="ParentName"))%>%
  filter(exist=="Yes")%>% #Get matches that matched the DAPIP database
  filter(Collaborators!="University of North Carolina at Chapel Hill")%>% #Remove abstracts from UNC-Chapel Hill
  group_by(Collaborators,Abstract)%>%
  unique()

#write a csv of joined data
write.csv(collab_match,file="collab_match.csv",row.names=F)


