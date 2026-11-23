
variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used in AWS resource tags"
  type        = string
  default     = "project1-ec2-webserver"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "Your public IPv4 address in CIDR format"
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "Provide a valid IPv4 CIDR, such as 203.0.113.10/32."
  }
}
