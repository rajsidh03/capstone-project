output "alb_url" {
  value = "http://${aws_lb.this.dns_name}"
}

output "target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "instance_1_id" {
  value = aws_instance.web[0].id
}

output "instance_2_id" {
  value = aws_instance.web[1].id
}
