locals {
  base_name = "${var.project}-${terraform.workspace}"
  workspace = terraform.workspace
}