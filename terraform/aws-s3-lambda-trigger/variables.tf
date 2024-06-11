variable "aws_s3_bucket_name" {
    description = "unique name of aws s3 bucket"
}

output "aws_s3_bucket_id" {
    description = "unique id of aws s3 bucket"
    value =  resource.aws_s3_bucket.aws_s3_bucket.id 
}