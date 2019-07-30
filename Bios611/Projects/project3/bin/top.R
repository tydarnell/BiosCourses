library(tidyverse)

args =commandArgs(trailingOnly=T)

#match with collaborators
matched <- read_csv(args[1])

matched %>%
  group_by(Collaborators)%>%
  summarise(Count=n())%>%
  top_n(10) #Top 10 collaborators (allowing ties)

#Join abstracts and collaborators
top10=left_join(collab_match,collab_df,key="Collaborators")


write.csv(top_collabs, file='top10.csv', row.names = FALSE)
