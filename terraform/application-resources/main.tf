// This is the main file is configure the network for the project 
locals {
  database_authentication_enabled = terraform.workspace == "prod" ? true : false
  domain_name                     = terraform.workspace == "prod" ? "api.${var.domain_name}" : "api.${terraform.workspace}.${var.domain_name}"
  photo_image_bucket              = "${var.project}-${terraform.workspace}-${random_string.random.result}-photo-video"
}

# VPC Subnet Internet Gateway
module "vpc-subnet-internet_gateway" {
  source = "../modules/vpc-subnet-internet_gateway"

  cidr_block               = var.cidr_block
  project                  = var.project
  availability_zones       = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  public_subnet_cidr_block = var.public_subnet_cidr_block
}

# Security Group
module "security_group" {
  source = "../modules/security_group"

  project                               = var.project
  vpc_id                                = module.vpc-subnet-internet_gateway.vpc_id
  security_group_http_cidr_blocks       = ["0.0.0.0/0"]
  security_group_http_ipv6_cidr_blocks  = ["::/0"]
  security_group_https_cidr_blocks      = ["0.0.0.0/0"]
  security_group_https_ipv6_cidr_blocks = ["::/0"]
  rds_security_group_cidr_blocks        = var.rds_security_group_cidr_blocks // Range IP access to RDS
}

# RDS
module "rds" {
  source                          = "../modules/rds"
  project                         = var.project
  engine                          = "postgres"
  engine_version                  = "16"
  instance_class                  = var.instance_class
  db_name                         = var.db_name
  username                        = var.username
  password                        = var.password
  allocated_storage               = var.allocated_storage
  storage_type                    = "io2"
  database_authentication_enabled = local.database_authentication_enabled || false
  backup_retention_period         = 0
  security_group_ids              = [module.security_group.rds_security_group_id]
  subnet_ids                      = concat(module.vpc-subnet-internet_gateway.subnet_ids)
}

# IAM ROLE
module "iam_role" {
  source  = "../modules/iam_role"
  project = var.project
}

# ECR
module "ecr" {
  source       = "../modules/ecr"
  project      = var.project
  mutability   = "MUTABLE"
  scan_on_push = false
}

# ACM
module "acm_certificate" {
  source                = "../modules/acm_certificate"
  domain_name           = local.domain_name
  validation_method     = "DNS"
  create_before_destroy = true
}

# Configure Route53 with acm
resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(module.acm_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(module.acm_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(module.acm_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = var.route53_zone_id
  ttl             = 60
}

# Create acm
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = module.acm_certificate.acm_certificate_arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

# Create Load balancer
module "load_balancing" {
  source              = "../modules/load_balancers"
  project             = var.project
  security_group_ids  = [module.security_group.backend_security_group_id]
  subnet_ids          = module.vpc-subnet-internet_gateway.subnet_ids
  vpc_id              = module.vpc-subnet-internet_gateway.vpc_id
  acm_certificate_arn = module.acm_certificate.acm_certificate_arn
  health_check_path   = "/api/health"
}

# Add route53 record
resource "aws_route53_record" "route53_record" {
  zone_id = var.route53_zone_id
  name    = local.domain_name
  type    = "A"
  alias {
    name                   = module.load_balancing.dns_name
    zone_id                = module.load_balancing.zone_id
    evaluate_target_health = false
  }
}

# Cloudwatch log group
resource "aws_cloudwatch_log_group" "cloudwatch_group" {
  name = "${var.project}-${terraform.workspace}-api"

  retention_in_days = 30
}

# Create Task definations, Cluters ECS, ECS services
module "ecs_service" {
  source                    = "../modules/ecs_services"
  project                   = var.project
  iam_role_arn              = module.iam_role.iam_role_arn
  repository_url            = module.ecr.repository_url
  aws_lb_target_group_arn   = module.load_balancing.aws_lb_target_group_arn
  container_port            = 80
  subnet_ids                = module.vpc-subnet-internet_gateway.subnet_ids
  security_group_ids        = [module.security_group.backend_security_group_id]
  aws_region                = var.aws_region
  cloudwatch_log_group_name = aws_cloudwatch_log_group.cloudwatch_group.name
}

# Function random string
resource "random_string" "random" {
  length  = 16
  upper   = false
  lower   = true
  special = false
  lifecycle {
    ignore_changes = [
      length,
      lower,
    ]
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.photo_image_bucket}",
      "arn:aws:s3:::${local.photo_image_bucket}/*"
    ]
  }
}

# Create S3 bucket
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.photo_image_bucket
  acl    = "public-read"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  control_object_ownership = true
  attach_policy            = true
  object_ownership         = "ObjectWriter"
  policy                   = data.aws_iam_policy_document.bucket_policy.json

  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["PUT", "POST", "GET", "DELETE"]
      allowed_origins = ["*"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  ]
  versioning = {
    enabled = true
  }
}
