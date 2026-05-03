# Production Repository
resource "aws_ecr_repository" "nodejs_web_app" {
  name                 = "nodejs-web-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Staging Repository
resource "aws_ecr_repository" "nodejs_web_app_staging" {
  name                 = "nodejs-web-app-staging"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Test Repository
resource "aws_ecr_repository" "nodejs_web_app_test" {
  name                 = "nodejs-web-app-test"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}