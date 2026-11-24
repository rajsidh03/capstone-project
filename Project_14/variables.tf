variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "p14-eks"
}

variable "node_instance_type" {
  description = "Worker server size"
  type        = string
  default     = "t3.small"
}
