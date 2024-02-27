terraform {
  required_version = ">= 1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "initialization"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-state-template-example"
    key    = "phases/initializations/initialize_environments/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

# Environment account
resource "aws_iam_user" "user" {
  for_each = { for environment in var.environments : environment.name => environment }

  name          = "${var.project_name}-${each.key}"
  force_destroy = false
}

# Attach policy
resource "aws_iam_user_policy" "user_policy" {
  for_each = { for environment in var.environments : environment.name => environment }

  name       = "${var.project_name}-${each.key}"
  user       = "${var.project_name}-${each.key}"
  policy     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
            "aws:RequestedRegion": "${each.value.region}"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "iam:GetAccountPasswordPolicy",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:ChangePassword",
      "Resource": "arn:aws:iam::*:user/${var.project_name}-${each.key}"
    },
    {
      "Effect": "Allow",
      "Action": [
         "s3:ListBucket",
         "s3:GetObject",
         "s3:PutObject",
         "s3:DeleteObject"
       ],
      "Resource": [
        "arn:aws:s3:::${each.key}-${var.bucket_state_storage_name}",
        "arn:aws:s3:::${each.key}-${var.bucket_state_storage_name}/*"
      ]
    }
  ]
}
EOF
  depends_on = [aws_iam_user.user]
}

# State storage bucket
resource "aws_s3_bucket" "state_storage" {
  for_each = { for environment in var.environments : environment.name => environment }

  bucket = "${each.key}-${var.bucket_state_storage_name}"

  tags = {
    Environment = each.key
  }
}
