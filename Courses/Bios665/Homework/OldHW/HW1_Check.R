
#Question 1 Check:

Question1<-matrix(c(29,51,45,35),ncol=2,byrow=TRUE)
colnames(Question1)<-c('FAV','UNFAV')
rownames(Question1)<-c('Placebo','Test')
Question1<-as.table(Question1)
Question1
summary(Question1)

#Question 2 Check:

Question2<-matrix(c(45,14,22,33),ncol=2,byrow=TRUE)
colnames(Question2)<-c('FAV','UNFAV')
rownames(Question2)<-c('HIGH_DOSE','LOW_DOSE')
Question2<-as.table(Question2)
Question2

install.packages('epitools')
library(epitools)
oddsratio(Question2)


Question2A<-matrix(c(7,2,3,4),ncol=2,byrow=TRUE)
colnames(Question2A)<-c('FAV','UNFAV')
rownames(Question2A)<-c('HIGH_DOSE','LOW_DOSE')
Question2A<-as.table(Question2A)
Question2A

fisher.test(Question2A)

#Question 3 Check:
Question3<-matrix(c(136,19,53,52),ncol=2,byrow=TRUE)
colnames(Question3)<-c('NTC','NTNC')
rownames(Question3)<-c('PC','PNC')
Question3<-as.table(Question3)
Question3

mcnemar.test(Question3,correct = FALSE)




