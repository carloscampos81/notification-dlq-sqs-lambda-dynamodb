locals {
  name = "${var.function_name}-${var.environment}"
}

resource "aws_lambda_function" "lambda_function" {
  function_name     = local.name
  s3_bucket         = var.s3_bucket_name
  s3_key            = "${aws_s3_object.file_upload.key}"
  role              = "${aws_iam_role.lambda_function_role.arn}"
  handler           = var.handler
  runtime           = var.runtime
  timeout           = 30
  source_code_hash = "${base64sha256(data.archive_file.source.output_path)}"

  lifecycle {
    create_before_destroy = true
  }
}