module "application-server" {
  source = "./application-server"

  ami_id               = "ami-0568312bcb6cecafd"
  iam_instance_profile = aws_iam_instance_profile.nodejs-web-app.name
  key_pair             = aws_key_pair.nodejs-web-app-key.key_name
  name                 = "nodejs Web App"

  subnet_id         = aws_subnet.subnet-public-web-app.id
  security_group_id = aws_security_group.allow-web-traffic.id

  repository_url         = aws_ecr_repository.nodejs_web_app.repository_url
  repository_test_url    = aws_ecr_repository.nodejs_web_app_test.repository_url
  repository_staging_url = aws_ecr_repository.nodejs_web_app_staging.repository_url

  admin_username = var.admin_username
  admin_password = var.admin_password
  admin_fullname = var.admin_fullname
  admin_email    = var.admin_email

  remote_repo = var.remote_repo
  job_name    = var.job_name
  job_id      = var.job_id

  bucket_config_name = var.bucket_config_name
}