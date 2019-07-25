cfun=function(fun,n){
  rhs <- paste("fun.", 1:n, "<-", fun, sep="")
  return(eval(parse(text=rhs)))
  
}
