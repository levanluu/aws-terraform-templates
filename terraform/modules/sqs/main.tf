data "aws_iam_policy_document" "sql_role_queue" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:*:*:${local.base_name}-${var.event_queue_name}"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["${var.source_arn}"]
    }
  }
}


resource "aws_sqs_queue" "event_queue" {
  name                       = "${local.base_name}-${var.event_queue_name}"
  delay_seconds              = 0
  visibility_timeout_seconds = var.timeout
  policy                     = data.aws_iam_policy_document.sql_role_queue.json
  redrive_policy = var.dead_letter_queue_arn != "" ? jsonencode({
    deadLetterTargetArn = var.dead_letter_queue_arn
    maxReceiveCount     = var.dead_letter_queue_max_receive_count
  }) : null
  tags = {
    enviroment = local.base_name
  }
}
