variable "bucket_name" {
  description = "S3 bucket name (must be globally unique if you ever apply this)"
  type        = string
  default     = "p11-branching-demo-logs"
}

resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name

  tags = { Name = "p11-logs-bucket" }
}
