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
data "aws_caller_identity" "current" {}

data "aws_route53_zone" "public" {
  name         = var.domain_name
  private_zone = false
}

module "application-resources" {
  source                         = "./application-resources"
  project                        = var.project
  aws_region                     = var.aws_region
  domain_name                    = var.domain_name
  cidr_block                     = var.cidr_block
  public_subnet_cidr_block       = var.public_subnet_cidr_block
  rds_security_group_cidr_blocks = var.rds_security_group_cidr_blocks
  instance_class                 = var.instance_class
  db_name                        = var.db_name
  username                       = var.username
  password                       = var.password
  allocated_storage              = var.allocated_storage
  route53_zone_id                = data.aws_route53_zone.public.zone_id
}

module "functionality" {
  source          = "./functionality"
  project         = var.project
  aws_region      = var.aws_region
  account_id      = data.aws_caller_identity.current.account_id
  route53_zone_id = data.aws_route53_zone.public.zone_id
}
