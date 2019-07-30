#! /usr/bin/python
from scipy.stats import norm
import sys
script,mu,sd,a=sys.argv
mu=int(mu)
sd=int(sd)
a=int(a)
def norm_prob(mu,sd,a):
    """Takes the mean, sd, and a number for the normal distribution and returns the probability from the normal PDF and CDF"""
    npdf=norm.pdf(a,mu,sd)
    ncdf=norm.cdf(a,mu,sd)
    print("prob from pdf = ",npdf,"\nprob from cdf = ",ncdf)
norm_prob(mu,sd,a)
