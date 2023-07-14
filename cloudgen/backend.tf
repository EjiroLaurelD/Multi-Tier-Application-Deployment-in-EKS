terraform {
  backend "s3" {
    bucket = "cloudgen-project"
    region = "us-east-1"
    key = "myapp/terraform.tfstate"
  }
}

