output "https_url" {
  value = "https://${aws_lb.this.dns_name}"
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "security_group_id" {
  value = aws_security_group.alb.id
}
