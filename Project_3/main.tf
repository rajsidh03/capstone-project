# ---------- Look up existing things (nothing is created here) ----------
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Use the account's DEFAULT VPC so we do not hit the VPC limit
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

# ---------- Security group: no inbound ports at all ----------
resource "aws_security_group" "instance" {
  name        = "${var.project_name}-sg"
  description = "No inbound access. Outbound allowed."
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg" }
}

# ---------- EC2 instance (generates CPU load by itself after boot) ----------
resource "aws_instance" "web" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.instance.id]

  # Detailed monitoring = CPU data every 1 minute instead of every 5
  monitoring = true

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    load_delay_seconds    = var.load_delay_seconds
    load_duration_seconds = var.load_duration_seconds
  })
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  tags = { Name = "${var.project_name}-ec2" }
}

# ---------- Optional: email notifications through SNS ----------
resource "aws_sns_topic" "alerts" {
  count = var.alert_email != "" ? 1 : 0
  name  = "${var.project_name}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.alert_email
}

locals {
  alarm_actions = var.alert_email != "" ? [aws_sns_topic.alerts[0].arn] : []
}

# ---------- The CloudWatch alarm ----------
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  alarm_description   = "CPU above ${var.cpu_threshold}% on ${var.project_name} EC2"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = var.alarm_period
  evaluation_periods  = var.evaluation_periods
  datapoints_to_alarm = var.evaluation_periods
  threshold           = var.cpu_threshold
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.alarm_actions
}
