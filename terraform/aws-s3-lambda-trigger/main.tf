####

#### create AWS s3 Bucket input

resource "aws_s3_bucket" "aws_s3_bucket_input" {
  bucket = var.aws_s3_bucket_name_input
  }

#### create AWS s3 Bucket output

resource "aws_s3_bucket" "aws_s3_bucket_output" {
  bucket = "${var.aws_s3_bucket_name_input}-resized"
  }

### Create AWS IAM Policy to access this bucket

resource "aws_iam_policy" "LambdaS3Policy" {
  name = var.aws_iam_policy_name
  path = "/"
  description = "AWS IAM Policy for Lambda to access S3 Bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.aws_s3_bucket_name_input}/*"
      },
            {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.aws_s3_bucket_name_input}-resized/*"
      },
    ]
  }) 
}

### Create AWS IAM Role for Lambda to access S3

resource "aws_iam_role" "LambdaS3Role" {
  name = var.aws_iam_role_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

### Attach IAM Policy and Role

resource "aws_iam_role_policy_attachment" "LambdaS3PolicyRoleattach" {
  role       = var.aws_iam_role_name
  policy_arn = aws_iam_policy.LambdaS3Policy.arn
}

### Create Lambda Function 
resource "aws_lambda_function" "CreateThumbnail" {
  filename      = var.aws_lambda_function_payload_filename
  function_name = var.aws_lambda_function_name
  role          = aws_iam_role.LambdaS3Role.arn
  handler       = var.aws_lambda_function_handler

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(var.aws_lambda_function_payload_filename)

  runtime = "nodejs18.x"
  timeout = 10
  memory_size = 1024
}

### Add permision for S3 bucket to invoke lambda function 

resource "aws_lambda_permission" "allowS3forCreateThumbnail" {
  statement_id  = "s3invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CreateThumbnail.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.aws_s3_bucket_input.arn
  source_account     = data.aws_caller_identity.current.account_id
}

### create S3 Bucket notification

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.aws_s3_bucket_input.id
  lambda_function {
    id = "CreateThumbnailEventConfiguration"
    lambda_function_arn     = aws_lambda_function.CreateThumbnail.arn
    events        = ["s3:ObjectCreated:Put"]
  }
}

### put image file to S3 bucket

resource "aws_s3_object" "ImagePut" {
  bucket = aws_s3_bucket.aws_s3_bucket_input.bucket
  key    = var.aws_s3_bucket_object_key
  source = var.aws_s3_bucket_object_source

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.aws_s3_bucket_object_source)

  depends_on = [aws_lambda_function.CreateThumbnail, aws_s3_bucket_notification.bucket_notification ]
}