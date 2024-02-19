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

resource "aws_s3_bucket" "state_storage" {
  bucket = var.bucket_state_storage_name
}
