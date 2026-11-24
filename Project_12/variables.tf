variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ci_mode" {
  description = "True in the pipeline: plan without contacting AWS"
  type        = bool
  default     = false
}

variable "bucket_name" {
  description = "S3 bucket name (must be globally unique if you ever apply this)"
  type        = string
  default     = "p12-plan-demo-bucket"
}
