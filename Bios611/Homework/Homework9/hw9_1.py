#! /usr/bin/python
import sys
cmdargs=sys.argv
cmdargs.remove(cmdargs[0])
for i in cmdargs:
    i=int(i)
    if i%2==0:
        print(i)
