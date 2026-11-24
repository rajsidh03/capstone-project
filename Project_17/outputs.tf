output "instance_id" {
  value = aws_instance.server.id
}

output "app_log_group" {
  value = aws_cloudwatch_log_group.app.name
}

output "system_log_group" {
  value = aws_cloudwatch_log_group.system.name
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.logs.dashboard_name
}
