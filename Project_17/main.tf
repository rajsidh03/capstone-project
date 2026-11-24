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

# ---------- CloudWatch log groups ----------
resource "aws_cloudwatch_log_group" "app" {
  name              = "${var.name_prefix}-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "system" {
  name              = "${var.name_prefix}-system"
  retention_in_days = 7
}

# ---------- IAM role so the server may write logs to CloudWatch ----------
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

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.server.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "server" {
  name = "${var.name_prefix}-server-profile"
  role = aws_iam_role.server.name
}

# ---------- Firewall: no inbound ports at all ----------
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

# ---------- The server (installs the agent and creates logs by itself) ----------
resource "aws_instance" "server" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.server.id]
  iam_instance_profile   = aws_iam_instance_profile.server.name

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    app_log_group    = aws_cloudwatch_log_group.app.name
    system_log_group = aws_cloudwatch_log_group.system.name
  })
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  tags = { Name = "${var.name_prefix}-server" }

  depends_on = [aws_iam_role_policy_attachment.cw_agent]
}

