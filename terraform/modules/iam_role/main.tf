data "aws_iam_policy_document" "role_document" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    effect = "Allow"
    sid    = "EcsTaskAssumeRole"
  }
}

data "aws_iam_policy_document" "policy_role_document" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "cloudwatch:*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "role" {
  name               = "${local.base_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.role_document.json
}

resource "aws_iam_instance_profile" "profile" {
  name = "${local.base_name}-ecs-task-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "policy" {
  name = "${local.base_name}-ecs-task-policy"
  role = aws_iam_role.role.id

  policy = data.aws_iam_policy_document.policy_role_document.json
}
