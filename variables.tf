variable "aws_access_key" {
  description = "your iam key"
}

variable "aws_secret_key" {
  description = "your iam secret key"
}

variable "aws_region" {
  description = "ex: ap-northeast-1"
  default = "ap-northeast-1"
}

variable "project_name" {
  description = "project name"
}

variable "environment" {
  description = "environment(choice dev, stg, prd)"
}

variable "vpc_cidr" {
  description = ""
}

