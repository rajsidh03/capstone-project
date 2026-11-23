variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix for tags"
  type        = string
  default     = "p6-version-control"
}

variable "bucket_name" {
  description = "S3 bucket name (must be globally unique if you ever apply this)"
  type        = string
  default     = "p6-version-control-demo-bucket"
}
