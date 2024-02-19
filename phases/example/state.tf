terraform {
  backend "s3" {
    bucket = "dev-terraform-state-template-example"
    key    = "phases/example/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
