#!/usr/bin/env bash
docker build -t py36 ~/Homework9/py36
docker pull frolvlad/alpine-python-machinelearning
docker run -d --rm -v $(pwd):$(pwd) -w $(pwd) py36 /bin/bash -c "python3 hw9_1.py 2 3 7 4 6 > /home/tdarnell/Homework9/output/output.txt" .
docker run -d --rm -v $(pwd):$(pwd) -w $(pwd) py36 /bin/bash -c "python3 hw9_2.py 5 2 17 >> /home/tdarnell/Homework9/output/output.txt" .
docker run -d --rm -v $(pwd):$(pwd) -w $(pwd) py36 /bin/bash -c "python3 hw9_3.py >> /home/tdarnell/Homework9/output/output.txt" .

docker run -d --rm -v $(pwd):$(pwd) -w $(pwd) frolvlad/alpine-python-machinelearning /bin/sh -c "python3 hw9_4.py 0 1 2 > /home/tdarnell/Homework9/output/hw9_4.txt" .
docker run -d --rm -v $(pwd):$(pwd) -w $(pwd) frolvlad/alpine-python-machinelearning /bin/sh -c "python3 hw9_5.py 3 5 > /home/tdarnell/Homework9/output/hw9_5.txt" .
ls output