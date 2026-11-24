# ---------- Existing default VPC and subnets ----------
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

# ---------- Self-signed certificate, imported into ACM ----------
resource "tls_private_key" "cert" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "cert" {
  private_key_pem       = tls_private_key.cert.private_key_pem
  validity_period_hours = 720
  dns_names             = ["p16.capstone.local"]
  allowed_uses          = ["key_encipherment", "digital_signature", "server_auth"]

  subject {
    common_name  = "p16.capstone.local"
    organization = "Capstone Project"
  }
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.cert.private_key_pem
  certificate_body = tls_self_signed_cert.cert.cert_pem

  tags = { Name = "${var.project_name}-self-signed" }
}

# ---------- Firewall: ONLY port 443 is open, so HTTP (port 80) is blocked ----------
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "HTTPS only. HTTP is blocked."
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-alb-sg" }
}

# ---------- The load balancer ----------
resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.default.ids

  tags = { Name = "${var.project_name}-alb" }
}

# ---------- HTTPS listener (port 443) with the ACM certificate ----------
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><body style=\"font-family:Arial,sans-serif;text-align:center;margin-top:100px\"><h1>Hello over HTTPS!</h1><p>Served by an Application Load Balancer using an ACM certificate.</p></body></html>"
      status_code  = "200"
    }
  }
}
