resource "aws_instance" "default" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  key_name = var.key_pair

  user_data = templatefile("${path.module}/user_data.sh", {
    repository_url         = var.repository_url
    repository_test_url    = var.repository_test_url
    repository_staging_url = var.repository_staging_url

    admin_username = var.admin_username
    admin_password = var.admin_password
    admin_fullname = var.admin_fullname
    admin_email    = var.admin_email

    remote_repo = var.remote_repo
    job_name    = var.job_name
    job_id      = var.job_id

    bucket_config_name = var.bucket_config_name
  })
}