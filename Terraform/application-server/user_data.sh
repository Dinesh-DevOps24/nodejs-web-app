#! /bin/bash
echo "Hello Application Server" >> /home/ec2-user/application_rc.txt

sudo yum update -y

# Install Docker
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo systemctl enable docker

# Login + run app from ECR
cat << EOT > start-website
#!/bin/bash
aws ecr get-login-password --region us-east-1 | docker login -u AWS --password-stdin ${repository_url}
docker pull ${repository_url}:release
docker run -d -p 80:8000 ${repository_url}:release
EOT

sudo mv start-website /var/lib/cloud/scripts/per-boot/start-website
sudo chmod +x /var/lib/cloud/scripts/per-boot/start-website
/var/lib/cloud/scripts/per-boot/start-website

# Install Git
sudo yum install -y git

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo dnf install java-11-amazon-corretto -y
sudo yum install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl daemon-reload

# Install Docker again (safe)
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker

# Allow docker access
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins

# Jenkins opt folder
sudo mkdir -p /var/lib/jenkins/opt
sudo chown jenkins:jenkins /var/lib/jenkins/opt

# Install Arachni
wget https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz
tar -zxf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz
rm arachni-1.5.1-0.5.12-linux-x86_64.tar.gz
sudo chown -R jenkins:jenkins arachni-1.5.1-0.5.12
sudo mv arachni-1.5.1-0.5.12 /var/lib/jenkins/opt

# ✅ FIXED PART (NO Terraform ERROR)

# Get instance ID from AWS metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Save values
echo "${repository_url}" | sudo tee /var/lib/jenkins/opt/repository_url
echo "${repository_test_url}" | sudo tee /var/lib/jenkins/opt/repository_test_url
echo "${repository_staging_url}" | sudo tee /var/lib/jenkins/opt/repository_staging_url
echo "$INSTANCE_ID" | sudo tee /var/lib/jenkins/opt/instance_id

# Hardcoded bucket name (safe fix)
echo "nodejs-web-app-logs" | sudo tee /var/lib/jenkins/opt/bucket_name

sudo chown -R jenkins:jenkins /var/lib/jenkins/opt/

# Wait for Jenkins
sleep 60

# Jenkins variables
PUBLIC_DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
export url="http://$PUBLIC_DNS:8080"
export user="${admin_username}"
export password="${admin_password}"
export admin_fullname="${admin_fullname}"
export admin_email="${admin_email}"
export remote="${remote_repo}"
export jobName="${job_name}"
export jobID="${job_id}"

# Copy config scripts from S3
aws s3 cp s3://${bucket_config_name}/ ./ --recursive
chmod +x *.sh

# Run scripts
./create_admin_user.sh
./download_install_plugins.sh
sleep 120
./confirm_url.sh
./create_credentials.sh

# Save credentials ID
python -c "import sys,json;print(json.loads(sys.stdin.read())['credentials'][0]['id'])" <<< $(./get_credentials_id.sh) > credentials_id

./create_multibranch_pipeline.sh

# Cleanup
rm *.sh credentials_id

reboot