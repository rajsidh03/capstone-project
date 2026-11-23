variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name used for tags"
  type        = string
  default     = "p2-static-site"
}

variable "bucket_prefix" {
  description = "Start of the bucket name (lowercase letters, numbers, hyphens only)"
  type        = string
  default     = "p2-static-site"
}
