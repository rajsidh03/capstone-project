output "aws_region" {
  value = var.aws_region
}

output "user_name" {
  value = aws_iam_user.s3_reader.name
}

output "policy_arn" {
  value = aws_iam_policy.s3_read.arn
}

output "bucket_name" {
  value = aws_s3_bucket.test.id
}

output "access_key_id" {
  value = var.create_access_key ? aws_iam_access_key.s3_reader[0].id : ""
}

output "secret_access_key" {
  value     = var.create_access_key ? aws_iam_access_key.s3_reader[0].secret : ""
  sensitive = true
}

output "user_arn" {
  value = aws_iam_user.s3_reader.arn
}
