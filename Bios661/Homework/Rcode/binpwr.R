n = 10
p = 0.5
a=.377

binpower=function(n,p,a,tail=c("right","left","both")){
sd = sqrt((p * (1 - p)/n))
c1<-qnorm(a/2,p,sd)
c2<-qnorm(1-a/2,p,sd)
p_hat_seq = seq(0, 1, 0.01)
if (tail=="right") {
  power=1-pnorm(c2,p_hat_seq,sd)
}
if(tail=="both"){
  power=pnorm(c1,p_hat_seq,sd)+1-pnorm(c2,p_hat_seq,sd)
}
else power=pnorm(c1,p_hat_seq,sd)

plot(p_hat_seq, power, type = "l",xlab=dplyr::expr(theta), ylab = "Power" )
}
