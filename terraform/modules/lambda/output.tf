output "arn" {
  description = "Lambda ARN"
  value       = aws_lambda_function.lambda_function.role
}

output "function_arn" {
  description = "Function ARN"
  value       = aws_lambda_function.lambda_function.arn
}