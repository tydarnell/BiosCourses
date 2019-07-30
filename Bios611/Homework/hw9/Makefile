folder:
	$(shell mkdir output)
	$(shell mkdir py36)

docker_file:
	$(shell printf "FROM python:3.6\nRUN pip install numpy\nRUN pip install pandas" > py36/Dockerfile)

docker_build:
	docker build -t py36 ~/Homework9/py36
	docker pull frolvlad/alpine-python-machinelearning

docker_run:
	docker run -d --rm -v $(shell pwd):$(shell pwd) -w $(shell pwd) py36 /bin/bash -c "python3 hw9_1.py 2 3 7 4 6 > /home/tdarnell/Homework9/output/output.txt" .
	docker run -d --rm -v $(shell pwd):$(shell pwd) -w $(shell pwd) py36 /bin/bash -c "python3 hw9_2.py 5 2 17 >> /home/tdarnell/Homework9/output/output.txt" .
	docker run -d --rm -v $(shell pwd):$(shell pwd) -w $(shell pwd) py36 /bin/bash -c "python3 hw9_3.py >> /home/tdarnell/Homework9/output/output.txt" .

docker_run2:
	docker run -d --rm -v $(shell pwd):$(shell pwd) -w $(shell pwd) frolvlad/alpine-python-machinelearning /bin/sh -c "python3 hw9_4.py 0 1 2 > /home/tdarnell/Homework9/output/hw9_4.txt" .
	docker run -d --rm -v $(shell pwd):$(shell pwd) -w $(shell pwd) frolvlad/alpine-python-machinelearning /bin/sh -c "python3 hw9_5.py 3 5 > /home/tdarnell/Homework9/output/hw9_5.txt" .

list_files:
	FILES="$(shell ls output)"