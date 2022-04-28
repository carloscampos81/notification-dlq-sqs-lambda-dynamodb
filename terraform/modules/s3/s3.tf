locals {
  bucket_name        =  "${var.name}-${var.environment}"
}

# Criação do Bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = local.bucket_name
  dynamic "lifecycle_rule" {
    for_each = var.bucket_cleanup ? [1] : []
    content {
      id      = "cleanup"
      enabled = true
      expiration {
        days = 14
      }
    }
  }
  acl    = "private"
  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}

# Adicionando Permissão ao Bucket
resource "aws_s3_bucket" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "TesteLambdaDynamoDB",
    "Statement": [
      {
        "Sid": "TesteLambdaDynamoDB",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": [
          "s3:GetObject*",
          "s3:GetBucket*",
          "s3:DeleteObject*",
          "s3:PutObject*",
          "s3:RestoreObject*",
          "s3:ListBucket"
        ],
        "Resource": [
          aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*",
        ]
      }
    ]
  })
}