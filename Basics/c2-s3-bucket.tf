#Randomly generated name for S3 bucket: yogesh-98765fgh
resource "random_string" "random_string_for_s3_bucket" {
  length  = 5
  special = false
  upper   = false
}

#Resource: AWS S3 Bucket

resource "aws_s3_bucket" "demo_s3_bucket" {
  bucket = "yogesh-${random_string.random_string_for_s3_bucket.result}"
  tags = {
    Name        = "yogesh-${random_string.random_string_for_s3_bucket.result}"
    Environment = "Dev"
  }
}
