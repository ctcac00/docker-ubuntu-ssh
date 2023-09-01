#!/bin/bash

docker stop ubuntu-ssh
docker rm ubuntu-ssh
docker build . -t ubuntu-ssh
docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host -p 22:22 --name ubuntu-ssh ubuntu-ssh
