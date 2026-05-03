# Random suffix for unique bucket names
resource "random_id" "bucket" {
  byte_length = 4
}

# Jenkins config bucket
resource "aws_s3_bucket" "jenkins_config" {
  bucket = "rapidcode-jenkins-config-${random_id.bucket.hex}"
}

# Logs bucket
resource "aws_s3_bucket" "nodejs_web_app_logs" {
  bucket = "rapidcode-nodejs-logs-${random_id.bucket.hex}"
}

# Upload Jenkins config files to S3
resource "aws_s3_object" "jenkins_config_files" {
  bucket   = aws_s3_bucket.jenkins_config.id
  for_each = fileset("jenkins-config/", "*")

  key    = each.value
  source = "jenkins-config/${each.value}"
  etag   = filemd5("jenkins-config/${each.value}")
}