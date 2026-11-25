output "bucket_name" {
  value = aws_s3_bucket.data.id
}

output "instance_id" {
  value = aws_instance.server.id
}

output "role_name" {
  value = aws_iam_role.ec2.name
}
