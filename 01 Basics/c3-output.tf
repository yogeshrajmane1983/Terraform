#Output block
output "s3_bucket_arn" {
  value = aws_s3_bucket.demo_s3_bucket.arn
  description = "s3 arn"
}

output "s3_bucket_id" {
  value = aws_s3_bucket.demo_s3_bucket.id
  description = "s3 bucket ID"
}