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

# No inbound rules at all (no SSH)
resource "aws_security_group" "server" {
  name        = "${var.name_prefix}-sg"
  description = "No inbound access"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-sg" }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.server.id]
  user_data              = file("${path.module}/user_data.sh")
  monitoring             = true # 1-minute metrics

  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  tags = { Name = "${var.name_prefix}-server" }
}

locals {
  id = aws_instance.server.id
  r  = var.aws_region
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.name_prefix}-monitoring"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric", x = 0, y = 0, width = 12, height = 6
        properties = {
          title   = "CPU Utilization (%)"
          region  = local.r
          view    = "timeSeries"
          stat    = "Average"
          period  = 60
          metrics = [["AWS/EC2", "CPUUtilization", "InstanceId", local.id]]
          yAxis   = { left = { min = 0, max = 100 } }
        }
      },
      {
        type = "metric", x = 12, y = 0, width = 12, height = 6
        properties = {
          title  = "Network In / Out (bytes)"
          region = local.r
          view   = "timeSeries"
          stat   = "Sum"
          period = 60
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", local.id],
            ["AWS/EC2", "NetworkOut", "InstanceId", local.id]
          ]
        }
      },
      {
        type = "metric", x = 0, y = 6, width = 12, height = 6
        properties = {
          title  = "Status Checks (0 = healthy)"
          region = local.r
          view   = "timeSeries"
          stat   = "Maximum"
          period = 60
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", local.id],
            ["AWS/EC2", "StatusCheckFailed_System", "InstanceId", local.id],
            ["AWS/EC2", "StatusCheckFailed_Instance", "InstanceId", local.id]
          ]
        }
      },
      {
        type = "metric", x = 12, y = 6, width = 12, height = 6
        properties = {
          title  = "Disk Read / Write (bytes)"
          region = local.r
          view   = "timeSeries"
          stat   = "Sum"
          period = 60
          metrics = [
            ["AWS/EC2", "EBSReadBytes", "InstanceId", local.id],
            ["AWS/EC2", "EBSWriteBytes", "InstanceId", local.id]
          ]
        }
      }
    ]
  })
}
