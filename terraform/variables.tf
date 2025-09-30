variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project to be used for resource mapping"
  type        = string
  default     = "web-app"
}

variable "environment" {
  description = "Environment (dev,prod)"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "key_name" {
  description = "SSH Key pair name"
  type        = string
  default     = "web-app-key"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The type of EC2 instance"
}

variable "admin_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR blocks allowed for SSH access"
}

variable "github_repo" {
  description = "Clone Github repo"
  type        = string
  default     = "https://github.com/gitongacollin/web-application.git"
}
