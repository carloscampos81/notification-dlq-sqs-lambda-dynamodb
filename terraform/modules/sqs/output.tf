output "dlq_arn" {
  description = "Lambda ARN"
  value       = aws_lambda_event_source_mapping.event_source_mapping
}