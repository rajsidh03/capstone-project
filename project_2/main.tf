# ---------- Random suffix (bucket names must be globally unique) ----------
resource "random_id" "suffix" {
  byte_length = 4
}

# ---------- 1. The bucket ----------
resource "aws_s3_bucket" "site" {
  bucket        = "${var.bucket_prefix}-${random_id.suffix.hex}"
  force_destroy = true # lets 'terraform destroy' delete the bucket even with files inside

  tags = { Name = "${var.project_name}-bucket" }
}

# ---------- 2. Turn on static website hosting ----------
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# ---------- 3a. Switch off the "block public access" safety lock (this bucket only) ----------
resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ---------- 3b. Bucket policy: everyone may READ files ----------
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.site.id

  # The policy must be added AFTER the public access block is relaxed
  depends_on = [aws_s3_bucket_public_access_block.site]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.site.arn}/*"
      }
    ]
  })
}

# ---------- 4. Upload the web pages ----------
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/index.html")
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.site.id
  key          = "error.html"
  source       = "${path.module}/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/error.html")
}
