module "example" {
  source          = "./example"
  project         = var.project
  aws_region      = var.aws_region
  account_id      = var.account_id
  route53_zone_id = var.route53_zone_id
}
