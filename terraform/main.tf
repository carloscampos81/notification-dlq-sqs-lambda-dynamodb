module "s3_dev" {
  source         = "./modules/s3"
  count          = length(var.s3_bucket_names)
  name           = var.s3_bucket_names[count.index].name
  bucket_cleanup = var.s3_bucket_names[count.index].bucket_cleanup
  environment    = "dev"
}


module "sqs_dev" {
  source             = "./modules/sqs"
  count              = length(var.sqs_queue_names)
  name               = var.sqs_queue_names[count.index].name
  visibility_timeout = 3600
  environment        = "dev"
  function_arn       = module.lambda_dev.function_arn
}

module "dynamodb_dev" {
  source       = "./modules/dynamodb"
  name         = "notification_dlq_lambda"
  environment  = "dev"
  billing_mode = "PROVISIONED"
  hash_key     = "id_mensagem"
  range_key    = "nome_fila"
  attributes = [
    {
      name = "id_mensagem"
      type = "S"
    },
    {
      name = "nome_fila"
      type = "S"
    },
  ]
  autoscale_min_read_capacity  = var.autoscaling_min_read_capacity
  autoscale_max_read_capacity  = var.autoscaling_max_read_capacity
  autoscale_min_write_capacity = var.autoscaling_min_write_capacity
  autoscale_max_write_capacity = var.autoscaling_max_write_capacity
}

module "lambda_dev" {
  source         = "./modules/lambda"
  function_name  = "notification_dlq_lambda_func"
  s3_bucket_name = "my-lambda-packages-dev"
  s3_key         = "notification_dlq_lambda.zip"
  handler        = "notification_dlq_lambda.handler"
  runtime        = "python3.9"
  role_arn       = module.lambda_dev.arn
  environment    = "dev"

  depends_on = [
    module.s3_dev, 
    module.dynamodb_dev
  ]
}