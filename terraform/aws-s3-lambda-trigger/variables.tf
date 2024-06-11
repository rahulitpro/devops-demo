variable "aws_s3_bucket_name_input" {
    description = "unique name of aws s3 bucket as input"
}


output "aws_s3_bucket_id_input" {
    description = "unique id of aws s3 bucket"
    value =  resource.aws_s3_bucket.aws_s3_bucket_input.id 
}

output "aws_s3_bucket_id_output" {
    description = "unique id of aws s3 bucket"
    value =  resource.aws_s3_bucket.aws_s3_bucket_output.id 
}

variable "aws_iam_policy_name" {
    description = "name of aws iam policy for lambda to access s3 bucket"
}

output "aws_iam_policy_arn" {
    description = "unique policy arn for lambda to access s3 bucket"
    value =  resource.aws_iam_policy.LambdaS3Policy.arn
  
}

variable "aws_iam_role_name" {
    description = "Name of the role for lambda to access S3 Bucket"
  
}

output "aws_iam_role_arn" {
    description = "Name of the role for lambda to access S3 Bucket as output"
    value = resource.aws_iam_role.LambdaS3Role.arn
}

output "aws_iam_role_policy_attachment_id" {
    description = "unique id for policy attachment"
    value = aws_iam_role_policy_attachment.LambdaS3PolicyRoleattach.id
  
}

variable "aws_lambda_function_payload_filename" {
    description = "Name and location for the file being used as payload in lambda function"
}

variable "aws_lambda_function_name" {
    description = "Name for the AWS lamdba funciton"
}

variable "aws_lambda_function_handler" {
    description = "Name of the AWS lambda function handler"
}

output "aws_lambda_function_arn" {
    description = "unique arn for aws_lambda_function CreateThumbnail"
    value = resource.aws_lambda_function.CreateThumbnail.arn
}

data "aws_caller_identity" "current" {}

variable "aws_s3_bucket_object_key" {
    description = "Name of the file to be uploaded to s3 bucket"
}

variable "aws_s3_bucket_object_source" {
   description = "location of the file to be uploaded to s3 bucket" 
}