set.seed(1)
dat <- matrix(rpois(24, rep(1:4, each = 6)), 6)


apply(dat,1,sum)%>%t()
dat/apply(dat,1,sum)
apply(dat,1,function(x) {x/sum(x)})

#formals
#body
compositional <- function(data,margin){
  a <- apply(data,margin,function(x) {x/sum(x)})
  if(margin==1) {a <- t(a)}
  return(a)
}


library(tidyverse)
dat2 <- read_tsv("GSE92332_AtlasFullLength_TPM.txt")
head(dat2)

x <- dat2[1,-1]%>%unlist()
y <- dat2[2,-1]%>%unlist()

data.frame(x=x,y=y)%>%
  ggplot(aes(x=x,y=y))+geom_point()

scatter <- function(data,x.index,y.index){
  x <- data[x.index,-1]%>%unlist()
  y <- data[y.index,-1]%>%unlist()
  
  data.frame(x=x,y=y)%>%
    ggplot(aes(x=x,y=y))+geom_point()+xlab(data[x.index,1]%>%as.character())
  +ylab(data[x.index,1]%>%as.character())
}