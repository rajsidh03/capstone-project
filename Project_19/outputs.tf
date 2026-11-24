output "bucket_name" {
  value = aws_s3_bucket.backup.id
}

output "instance_id" {
  value = aws_instance.server.id
}
