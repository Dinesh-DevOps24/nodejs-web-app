variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ami_id" {
  description = "AMI ID"
}




variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "admin_fullname" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "remote_repo" {
  type = string
}

variable "job_name" {
  type = string
}

variable "secrets" {
  type = map(string)
}


variable "job_id" {}
variable "bucket_config_name" {}