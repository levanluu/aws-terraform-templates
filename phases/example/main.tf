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
  default_tags {
    tags = {
      Environment = terraform.workspace
    }
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "${terraform.workspace}-${var.bucket_example_name}"
}
