output "name" {
  description = "Dynamodb Table Name"
  value       = aws_dynamodb_table.dynamodb_table.name
}

output "arn" {
  description = "Dynamodb ARN"
  value       = aws_dynamodb_table.dynamodb_table.arn
}

output "stream_arn" {
  description = "Dynamodb ARN"
  value       = aws_dynamodb_table.dynamodb_table.stream_arn
}

output "resource_id" {
  description = "Dynamodb Resource ID"
  value       = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
}

output "scalable_dimension" {
  description = "Dynamodb Scalable Dimension"
  value       = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
}

output "namespace" {
  description = "Dynamodb Namespace"
  value       = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace
}