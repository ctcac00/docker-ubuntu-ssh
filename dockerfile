FROM ubuntu:latest

RUN apt update && apt install  openssh-server sudo -y 

RUN apt-get -y install python3-pip iputils-ping python3.8-venv curl
RUN pip3 install pymongo==4.0.1 faker dnspython
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
RUN echo 'deb [ arch=amd64,arm64 ] http://repo.mongodb.com/apt/ubuntu bionic/mongodb-enterprise/5.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list
RUN apt-get update
RUN apt-get install -y mongodb-mongosh

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu 

RUN echo 'ubuntu:ubuntu' | chpasswd

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]