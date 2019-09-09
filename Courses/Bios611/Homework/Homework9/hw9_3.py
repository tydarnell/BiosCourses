#! /usr/bin/python
import pandas as pd
import numpy as np
np.random.seed(0)
data=[]
for i in range(5):
    data.append(np.random.rand(20))
df=np.transpose(pd.DataFrame(data))
for i in df:
    print("mean of column",i,"=",np.mean(df[i]))
