# ---------- Random suffix (keeps names unique in a shared account) ----------
resource "random_id" "suffix" {
  byte_length = 4
}

# ---------- A private test bucket with one file, to test the policy against ----------
resource "aws_s3_bucket" "test" {
  bucket        = "${var.bucket_prefix}-${random_id.suffix.hex}"
  force_destroy = true

  tags = { Name = "${var.project_name}-test-bucket" }
}

resource "aws_s3_object" "hello" {
  bucket       = aws_s3_bucket.test.id
  key          = "hello.txt"
  content      = "Hello from Project 4! If you can read this, the IAM read policy works.\n"
  content_type = "text/plain"
}

# ---------- 1. The IAM user ----------
resource "aws_iam_user" "s3_reader" {
  name          = "${var.user_name}-${random_id.suffix.hex}"
  force_destroy = true # lets 'terraform destroy' delete the user together with its access key

  tags = {
    Project = var.project_name
    Purpose = "S3 read-only test user"
  }
}

# ---------- 2. The policy (built from the variable) ----------
data "aws_iam_policy_document" "s3_read" {
  statement {
    sid     = "S3ReadOnlyTestBucket"
    effect  = "Allow"
    actions = var.s3_read_actions

    resources = [
      aws_s3_bucket.test.arn,
      "${aws_s3_bucket.test.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_read" {
  name        = "${var.project_name}-s3-read-${random_id.suffix.hex}"
  description = "Read-only access to the Project 4 test bucket"
  policy      = data.aws_iam_policy_document.s3_read.json
}

# ---------- 3. Attach the policy to the user ----------
resource "aws_iam_user_policy_attachment" "s3_read" {
  user       = aws_iam_user.s3_reader.name
  policy_arn = aws_iam_policy.s3_read.arn
}

# ---------- 4. Access key so we can test from the CLI ----------
resource "aws_iam_access_key" "s3_reader" {
  count = var.create_access_key ? 1 : 0
  user  = aws_iam_user.s3_reader.name
}
