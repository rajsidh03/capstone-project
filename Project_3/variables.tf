variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "p3-monitoring"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "cpu_threshold" {
  description = "Alarm fires when average CPU % is above this value"
  type        = number
  default     = 70
}

variable "alarm_period" {
  description = "Length of each measurement window in seconds"
  type        = number
  default     = 60
}

variable "evaluation_periods" {
  description = "How many windows in a row must breach before the alarm fires"
  type        = number
  default     = 2
}

variable "load_delay_seconds" {
  description = "Wait this long after boot before the CPU load starts"
  type        = number
  default     = 180
}

variable "load_duration_seconds" {
  description = "How long the CPU load runs"
  type        = number
  default     = 1200
}

variable "alert_email" {
  description = "Email for alarm notifications via SNS. Leave empty to skip email."
  type        = string
  default     = ""
}
