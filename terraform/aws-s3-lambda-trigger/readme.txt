Reference Totorial : https://docs.aws.amazon.com/lambda/latest/dg/with-s3-tutorial.html

Additional files required to run this project not in git repo for security, use below templates to create these files with your values.


1. terraform.tfvars
 
aws_s3_bucket_name_input = ""
aws_iam_policy_name = ""
aws_iam_role_name = ""
aws_lambda_function_payload_filename = ""
aws_lambda_function_name = ""
aws_lambda_function_handler = ""
aws_s3_bucket_object_key = ""
aws_s3_bucket_object_source = ""

2. backend.tf

terraform {  
    backend "s3" {    
        bucket = ""    
        key    = ""   
        region = ""
        dynamodb_table = ""
        }
    }

Trigger project with below example awscli command 

aws s3api put-object --bucket Source_bucket_name --key SmileyFace2.jpg --body ./SmileyFace.jpg
