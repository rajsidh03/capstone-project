data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "logs" {
  bucket        = "${var.name_prefix}-log-archive-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = { Name = "${var.name_prefix}-log-archive" }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "archive-then-expire-logs"
    status = "Enabled"

    filter {
      prefix = "logs/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_object" "sample" {
  for_each = toset(["app", "web", "system"])

  bucket       = aws_s3_bucket.logs.id
  key          = "logs/${each.key}.log"
  content      = "sample ${each.key} log entry from project 22\n"
  content_type = "text/plain"
}
