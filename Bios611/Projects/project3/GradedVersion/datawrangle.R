library(shiny)
library(tidyverse)
library(data.table)
library(bit64)
library(tm)

setwd("C:/Users/tydar/OneDrive/Documents/Bios611/project3/p2_abstracts")

files<-list.files()

abstracts_df<-tibble("Authors"=character(),"Abstract"=character()) #Create a tibble, will store author and absract info
institutions_df<-fread("InstitutionCampus.csv") #read in the csv of accrediated institutions

for(i in 1:nrow(institutions_df)){
  if(institutions_df[i,4]=="-"){
    institutions_df[i,4]=institutions_df[i,3]
  } else {
    institutions_df[i,4]=institutions_df[i,4]
  }
}

#Make a unique list of  institutions for matching 

institutions_match<-institutions_df[,4]%>%mutate(exist="Yes")%>%unique() 

for(i in files){
  full_file<-readLines(i)
  for (j in 1:length(full_file)){
    if(substring(full_file[j],1,6)=="Author"){
      abstracts_df[i,1]=full_file[j]
      abstracts_df[i,2]=casefold(full_file[j+1]) #Make abstracts lower case
    }
  }
}

#Make abstracts lower case; split authors by (#) and then split that further by ","
authors_df=abstracts_df


collab_df<-tibble("Collaborators"=character(),"Abstract"=character()) #Create an empty tibble to store the split collaborator info

m=0
for (i in 1:nrow(authors_df)){
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
  unique()%>%
  group_by(Collaborators)%>%
  summarise(Count=n())%>%
  top_n(10) #Top 10 collaborators (allowing ties)

#Join abstracts and collaborators
top10=left_join(collab_match,collab_df,key="Collaborators")

#write a csv of joined data
write.csv(top10,file="top10.csv",row.names=F)


