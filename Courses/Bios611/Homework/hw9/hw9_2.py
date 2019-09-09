#! /usr/bin/python
x=[1,6,9,8,14]
import sys
script,a,b,c=sys.argv
v=[int(a),int(b),int(c)]
x.extend(v)
print(len(x))
print(x)
y=sorted(x)
print(y)
