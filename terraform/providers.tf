terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9"
    }
  }
  backend "s3" {
  bucket = "collin-web"
  key = ""
  region = "us-east-1"
    }
}
provider "aws" {
  region = var.aws_region
}

