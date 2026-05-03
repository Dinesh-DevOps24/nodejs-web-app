#! /bin/bash

echo "Hello Jenkins Server" > /home/ec2-user/jenkins.txt

# Update system
sudo yum update -y

# Install Java
sudo dnf install java-11-amazon-corretto -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Docker
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo systemctl enable docker

# Allow Jenkins to use Docker
sudo usermod -aG docker jenkins
