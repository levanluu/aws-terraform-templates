output "sqs_arn" {
  description = "The SQS upload firmware ARN."
  value       = aws_sqs_queue.event_queue.arn
}
output "sqs_id" {
  description = "The SQS capture job execution action id."
  value       = aws_sqs_queue.event_queue.id
}
