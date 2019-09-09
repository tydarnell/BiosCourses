mean_by_col=function(data){
  res=vector()
  for(i in names(data)){
    res[i]=mean(data[[i]],na.rm = T)
  } 
  res
}

mean.not=as_tibble(mean_by_col(not.mean))

mean.in = as_tibble(mean_by_col(in.mean))