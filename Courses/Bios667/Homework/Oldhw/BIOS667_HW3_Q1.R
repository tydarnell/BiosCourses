#BIOS 667 HW 3 due November 1

data<-NULL
data$control<-c(0.139,0.110,0.110,0.213)
data$noshow<-c(0.248,0.169,0.141,0.187)
data$tx1<-c(0.303,0.204,0.164,0.201)
data$tx2<-c(0.428,0.281,0.209,0.208)
data<-as.data.frame(data)
rownames(data)<-c("T0","T1","T2","T4")
colnames(data)<-c("control","noshow","tx1","tx2")
data$time<-rownames(data)

library(ggplot2)
library(reshape)


data_melt<-melt(data,id=c('time'))
p<-ggplot(data=data_melt, aes(x=time, y=value, group=variable)) + geom_line(aes(color=variable))
p<- p + labs(y = "Estimated Cell Probabilities")
p<- p + labs(x = "Time" )
p<- p + labs(title = "Estimated Cell Probabilities Over Time for Each Treatment")
p + labs(colour = "Treatments")



#Question 2

VP = matrix(c(0.0077,0.0043,0.0034,0.0043,0.0081,0.0063,0.0034,0.0063,0.0113),nrow=3,ncol=3) 

BP= matrix(c(0.9013,0.9611,0.8485),nrow=3,ncol=1)


VA = matrix( c(0.0408,0.0287,0.0181,0.0287,0.0434,0.0159,0.0181,0.0159,0.0533),nrow=3, ncol=3) 

BA= matrix(c(0.6135,0.6005,0.9118),nrow=3,ncol=1)


Delta=BA-BP
V=VA+VP

#test 
t(Delta)%*%solve(V)%*%Delta


#find pvalue

pchisq(3.673,3)


2*pnorm(-abs(1.308))
2*pnorm(-abs(1.59))
2*pnorm(-abs(0.252))
