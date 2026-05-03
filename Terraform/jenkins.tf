module "jenkins" {
  source = "./jenkins-server"

  ami-id               = "ami-0568312bcb6cecafd"
  iam-instance-profile = aws_iam_instance_profile.jenkins.name
  key-pair             = aws_key_pair.jenkins_key.key_name
  name                 = "jenkins"
  device-index         = 0

  network-interface-id = aws_network_interface.jenkins.id

  repository-url         = aws_ecr_repository.nodejs_web_app.repository_url
  repository-test-url    = aws_ecr_repository.nodejs_web_app_test.repository_url
  repository-staging-url = aws_ecr_repository.nodejs_web_app_staging.repository_url

  instance-id = module.application-server.instance_id
  public-dns  = aws_eip.jenkins.public_dns

  admin-username = var.admin_username
  admin-password = var.admin_password
  admin-fullname = var.admin_fullname
  admin-email    = var.admin_email

  bucket-logs-name   = aws_s3_bucket.nodejs_web_app_logs.id
  bucket-config-name = aws_s3_bucket.jenkins_config.id

  remote-repo = var.remote_repo
  job-name    = var.job_name
  job-id      = random_id.job-id.id
}

resource "random_id" "job-id" {
  byte_length = 16
}