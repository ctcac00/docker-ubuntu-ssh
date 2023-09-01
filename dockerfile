FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies.
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  apt-utils \
  build-essential \
  software-properties-common \
  rsyslog systemd \
  systemd-cron sudo iproute2 \
  openssh-server \
  vim \
  python3-pip iputils-ping python3.10-venv \
  gnupg curl wget\
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc && rm -Rf /usr/share/man
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target

# Install mongosh
RUN pip3 install pymongo==4.0.1 faker dnspython
RUN curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
  --dearmor
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.com/apt/ubuntu jammy/mongodb-enterprise/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise-7.0.list
RUN apt-get update
RUN apt-get install -y mongodb-mongosh

# Set up configuration for SSH
RUN mkdir /var/run/sshd

# SSH login fix. Otherwise, user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN useradd -m ubuntu -s /usr/bin/bash && echo "ubuntu:ubuntu" | chpasswd && adduser ubuntu sudo
RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ubuntu

RUN mkdir /home/ubuntu/.ssh
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZzfJp/oSgsG6TqxDjx2SiIlkkbkE5/zzNpi/gNy8Qu carlos.castro@mongodb.com" >> /home/ubuntu/.ssh/authorized_keys

# Expose the SSH port
EXPOSE 22

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]