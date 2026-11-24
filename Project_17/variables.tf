variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix for resource and log group names (kept unique in the shared account)"
  type        = string
  default     = "p17-rajsidh03"
}

variable "instance_type" {
  description = "Server size"
  type        = string
  default     = "t3.micro"
}
