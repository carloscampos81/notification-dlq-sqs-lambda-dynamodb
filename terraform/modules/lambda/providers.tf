data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    actions    = ["sts:AssumeRole"]
    effect     = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Zip the Lamda function on the fly
data "archive_file" "source" {
  type        = "zip"
  source_dir  = pathexpand("../python")
  output_path = pathexpand("../my-lambda-packages/notification_dlq_lambda.zip")
  excludes    = ["__init__.py", "*.pyc"]
  #source_dir  = "${path.module}/script"
  #output_path = "${path.module}/lambda_package/notification_dlq_lambda.zip"
}

resource "aws_s3_object" "file_upload" {
  bucket =  var.s3_bucket_name
  key    =  var.s3_key
  source = "${data.archive_file.source.output_path}" # its mean it depended on zip
}