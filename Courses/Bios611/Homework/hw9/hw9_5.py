#! /usr/bin/python
import sys
import numpy as np
script,x,y=sys.argv
x=int(x)
y=int(y)
def squaredsum(x,y):
    """takes two values and returns the squared sum over the interval"""
    i=list(range(x,y+1))
    ans=0
    for j in i:
        ans+=np.sum(j**2)
    return ans
print(squaredsum(x,y))
