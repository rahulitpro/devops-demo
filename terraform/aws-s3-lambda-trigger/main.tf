####

#### create AWS s3 Bucket

resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = var.aws_s3_bucket_name
  }