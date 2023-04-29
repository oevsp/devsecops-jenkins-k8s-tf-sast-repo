#!/bin/bash

# Install Updated packages on linux machine
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade

# Install JDK, Apache Maven, Jenkins
sudo amazon-linux-extras install java-openjdk11
sudo yum install git -y
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
sudo yum install jenkins -y

# Change local port for Jenkins 8081 
sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=8081"/' /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl status jenkins
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
sudo yum install unzip
sudo unzip awscliv2.zip  
sudo ./aws/install

#ZAP is installed at /home/ec2-user/ZAP_2.11.1/zap.sh
sudo wget https://github.com/zaproxy/zaproxy/releases/download/v2.11.1/ZAP_2_11_1_unix.sh
sudo chmod +x ZAP_2_11_1_unix.sh 
sudo ./ZAP_2_11_1_unix.sh -q
sudo tar -xvf ZAP_2.11.1_Linux.tar.gz

# Install Kubernetes CLI & Docker
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
sudo cp kubectl /usr/local/bin/
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
sudo yum install docker -y

# Adding users to docker group and starting docker & jenkins
sudo usermod -aG docker $USER
sudo newgrp docker
sudo usermod -aG docker jenkins
sudo newgrp docker
sudo service jenkins restart
sudo systemctl daemon-reload
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

# Utility for parsing JSON
sudo yum install jq -y