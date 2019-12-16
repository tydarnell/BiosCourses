#contingency table function (enter data by row from left to right)
ctab=function(a,b,c,d){
  tab=as.table(matrix(c(a,b,c,d),nrow=2,byrow = T))
  tab
}

#Get Expected value and variance under H0 of no treatment difference of 2x2 table
mvtab=function(tab){
  tab=addmargins(tab)
  E=(tab[1,3]*tab[3,1])/tab[3,3]
  V=(tab[1,3]*tab[3,1]*tab[2,3]*tab[3,2])/(tab[3,3]^2*(tab[3,3]-1))
  paste("expected value:",round(E,3),"variance:",round(V,3))
}

#function for expected value of 2x2 table under null of no difference
ectab=function(tab){
  tab=addmargins(tab)
  (tab[1,3]*tab[3,1])/tab[3,3]
}

#function for variance of 2x2 table under null of no difference
vctab=function(tab){
  tab=addmargins(tab)
  (tab[1,3]*tab[3,1]*tab[2,3]*tab[3,2])/(tab[3,3]^2*(tab[3,3]-1))
}

#cochran mantel haenszel function
cmh=function(a,b){
  a=addmargins(a)
  b=addmargins(b)
  ea=(a[1,3]*a[3,1])/a[3,3]
  va=(a[1,3]*a[3,1]*a[2,3]*a[3,2])/(a[3,3]^2*(a[3,3]-1))
  eb=(b[1,3]*b[3,1])/b[3,3]
  vb=(b[1,3]*b[3,1]*b[2,3]*b[3,2])/(b[3,3]^2*(b[3,3]-1))
  nh11=a[1,1]+b[1,1]
 cmh=(nh11-(ea+eb))^2/(va+vb)
 cmh
}

#mantel-fleiss criterion function (criterion greater than 5 means chi-square appropriate)
mfc=function(a,b){
  a=addmargins(a)
  b=addmargins(b)
  ea= (a[1,3]*a[3,1])/a[3,3]
  eb= (b[1,3]*b[3,1])/b[3,3]
  e=(ea+eb)
  l1=max(0,a[1,3]-b[3,1])
  l2=max(0,b[1,3]-a[3,1])
  l=l1+l2
  first=e-l
  u1=min(a[1,3],a[3,1])
  u2=min(b[1,3],b[3,1])
  u=u1+u2
  last=u-e
  mfc=min(first,last)
  mfc
}

a=ctab(29,16,14,31) #table 1 (1st strata)
b=ctab(37,8,24,21) #table 2 (2nd strata)
d=array(c(a,b),dim=c(2,2,2)) #combined table
mantelhaen.test(d,correct = F) #use correct=F

chisq.test(a,correct = F) #chi-square for center 1
chisq.test(b,correct = F) #chi-square for center 2

library(DescTools) #for breslow day test
BreslowDayTest(d) #breslow day test for homogeneity of odds ratios
