# Turn log lines into metrics (a count per log level) so a dashboard can chart them
resource "aws_cloudwatch_log_metric_filter" "levels" {
  for_each = toset(["INFO", "WARN", "ERROR"])

  name           = "${var.name_prefix}-${lower(each.key)}-count"
  log_group_name = aws_cloudwatch_log_group.app.name
  pattern        = each.key

  metric_transformation {
    name          = "${each.key}Count"
    namespace     = "P17Logs"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_dashboard" "logs" {
  dashboard_name = "${var.name_prefix}-logs"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 8
        properties = {
          title  = "Application log events by level (forwarded by the CloudWatch agent)"
          region = var.aws_region
          view   = "timeSeries"
          stat   = "Sum"
          period = 60
          metrics = [
            ["P17Logs", "INFOCount"],
            ["P17Logs", "WARNCount"],
            ["P17Logs", "ERRORCount"],
          ]
        }
      }
    ]
  })
}
