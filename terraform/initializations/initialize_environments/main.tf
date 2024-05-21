terraform {
  required_version = ">= 1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29"
    }
    pgp = {
      source  = "ekristen/pgp"
      version = "0.2.4"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "initialization"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-example"
    key            = "terraform/initializations/initialize_environments/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-dynamodb-example"
    encrypt        = true
  }
}

# Route 53
resource "aws_route53_zone" "main" {
  name = var.host_name
}

# Set up OIDC to deploy Automation
module "github-oidc" {
  source  = "terraform-module/github-oidc-provider/aws"
  version = "~> 1"

  create_oidc_provider = true
  create_oidc_role     = true

  repositories              = var.repositories
  oidc_role_attach_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

# Set up monitoring billing
module "lambda_function_monitorinig_billing" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.project_name}-monitorinig-billing"
  description   = "AWS Lambda monitoring billing"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  timeout       = 40
  publish       = true
  environment_variables = {
    "SLACK_WEBHOOK_URL" = var.slack_webhook_url
  }

  source_path              = "./lambdas/monitoring-billing"
  attach_policy_statements = true
  policy_statements = {
    manage_billing = {
      effect    = "Allow",
      actions   = ["ce:GetCostAndUsage", "iam:ListAccountAliases"],
      resources = ["*"]
    }
  }
}
resource "aws_cloudwatch_event_rule" "event_rule_lambda" {
  name                = "report-billing-daily"
  description         = "Run lambda everyday 02:00 UTC"
  schedule_expression = "cron(0 2 * * ? *)"
}
