N=c(129,243,478,470,387,441,300,210)
n=c(8,53,135,134,44,138,130,102)
p=c(.062,.218,.282,.285,.114,.313,.433,.486)
pop=c(rep("urban",4),rep("rural",4))
age=c(1,2,3,4,1,2,3,4)
data = data.frame(N,n,p,pop,age) %>%               
  reshape(idvar="age", timevar="pop", direction="wide")
print(data)                                            #original dataset (see pg 13)

#DIRECT STANDARDIZATION APPROACH
data %>%
  mutate(varPropUrban = p.urban*(1-p.urban)/N.urban,   #variances of urban smoking proportions for each age group (see pg 20)
         varPropRural = p.rural*(1-p.rural)/N.rural,   #variances of rural smoking proportions (see pg 20)
         N.total=N.urban+N.rural,                      #aggregate sample sizes for age groups (see pg 14)
         weights = N.total/sum(N.total)) %>%           #weights (see pg 14)
  summarize(stdPropUrban = sum(p.urban*weights),       #standardized urban smoking proportion (see pg 16)
            stdPropRural = sum(p.rural*weights),       #standardized rural smoking proportion (see pf 16)
            adjDiff = stdPropUrban-stdPropRural,       #age-adjusted difference (see pg 16)
            varAdjDiff = sum(weights^2*(varPropUrban+varPropRural))/sum(weights)^2,   #variance of difference (see pg 22)
            Z = (adjDiff)/sqrt(varAdjDiff),            #test statistic (see pg 22) 
            pValue = pnorm(Z))                         #p-value

#INDRECT STANDARDIZATION APPROACH
data %>% 
  mutate(referencePop = n.urban/N.urban,    #reference (urban) proportions (see pg 27) (identical to 'p.urban' column)
         expect=N.rural*referencePop) %>%   #expected smokers for each age group (see pg 27/29)
  summarize(observed = sum(n.rural),        #observed overall rural smokers (see pg 27)
            expected=sum(expect),           #expected overall rural smokers (see pg 27)
            s = observed/expected,          #standardized incidence ratio (SIR) (see pg 27)
            varObserved = observed,         #variance of observed smokers (see pg 28)
            varExpected = sum((N.rural/N.urban)^2*n.urban),    #variance of expected smokers (see pg 28)
            varS = (varObserved+s^2*varExpected)/expected^2,   #variance of SIR (see pg 28)
            Z = (s-1)/sqrt(varS),           #test statistic (see pg 28)
            pVal = pnorm(Z))                #p-value