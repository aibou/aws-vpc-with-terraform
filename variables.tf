variable "aws_profile" {
  description = "your aws profile"
  default = "default"
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

