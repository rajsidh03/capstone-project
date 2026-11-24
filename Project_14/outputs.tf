output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "connect_command" {
  value = "aws eks update-kubeconfig --name ${aws_eks_cluster.this.name} --region ${var.aws_region}"
}
