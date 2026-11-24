data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

# ---------- Private S3 bucket for the backups ----------
resource "aws_s3_bucket" "backup" {
  bucket        = "${var.name_prefix}-log-backup-${random_id.suffix.hex}"
  force_destroy = true

  tags = { Name = "${var.name_prefix}-log-backup" }
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------- IAM role: the server may only write to this one bucket ----------
resource "aws_iam_role" "server" {
  name = "${var.name_prefix}-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "backup" {
  name = "${var.name_prefix}-backup-policy"
  role = aws_iam_role.server.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.backup.arn}/backups/*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.backup.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "server" {
  name = "${var.name_prefix}-server-profile"
  role = aws_iam_role.server.name
}

# ---------- Firewall: no inbound ports ----------
resource "aws_security_group" "server" {
  name        = "${var.name_prefix}-sg"
  description = "No inbound access. Outbound allowed."
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-sg" }
}

# ---------- The server with the cron backup job ----------
resource "aws_instance" "server" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.server.id]
  iam_instance_profile   = aws_iam_instance_profile.server.name

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    bucket_name = aws_s3_bucket.backup.id
    region      = var.aws_region
  })
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  tags = { Name = "${var.name_prefix}-server" }
}
