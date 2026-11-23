variable "aws_region" {
  description = "AWS region for the test bucket (IAM itself is global)"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix for resources and tags"
  type        = string
  default     = "p4-iam"
}

variable "user_name" {
  description = "Base name of the IAM user (a random suffix is added)"
  type        = string
  default     = "p4-s3-readonly-user"
}

variable "bucket_prefix" {
  description = "Start of the test bucket name (lowercase letters, numbers, hyphens)"
  type        = string
  default     = "p4-test-bucket"
}

# The "policy stored as a variable": the list of S3 actions the user may perform.
# Change this list and run 'terraform apply' to change the user's permissions.
variable "s3_read_actions" {
  description = "S3 actions allowed by the read-only policy"
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket",
    "s3:GetBucketLocation"
  ]
}

variable "create_access_key" {
  description = "Create an access key so the user can be tested from the CLI"
  type        = bool
  default     = false
}
