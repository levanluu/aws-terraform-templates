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

resource "aws_iam_access_key" "user_access_key" {
  for_each = { for environment in var.environments : environment.name => environment }

  user       = "${var.project_name}-${each.key}"
  depends_on = [aws_iam_user.user]
}

resource "pgp_key" "user_login_key" {
  for_each = { for environment in var.environments : environment.name => environment }

  name    = "${var.project_name}-${each.key}"
  email   = var.team_email
  comment = "PGP Key for ${var.project_name}-${each.key}"
}

resource "aws_iam_user_login_profile" "user_login" {
  for_each = { for environment in var.environments : environment.name => environment }

  user                    = "${var.project_name}-${each.key}"
  pgp_key                 = pgp_key.user_login_key[each.key].public_key_base64
  password_reset_required = true

  depends_on = [aws_iam_user.user, pgp_key.user_login_key]

  lifecycle {
    ignore_changes = [password_reset_required]
  }
}

data "pgp_decrypt" "user_password_decrypt" {
  for_each = { for environment in var.environments : environment.name => environment }

  ciphertext          = aws_iam_user_login_profile.user_login[each.key].encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.user_login_key[each.key].private_key
}

output "credentials" {
  value = {
    for k, v in { for environment in var.environments : environment.name => environment } : k => {
      "key"      = aws_iam_access_key.user_access_key[k].id
      "secret"   = aws_iam_access_key.user_access_key[k].secret
      "username" = "${var.project_name}-${k}"
      "password" = data.pgp_decrypt.user_password_decrypt[k].plaintext
    }
  }
  sensitive = true
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
      "Resource": "arn:aws:s3:::${each.key}-${var.bucket_state_storage_name}"
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
