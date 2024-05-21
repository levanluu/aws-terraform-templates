terraform {
  backend "s3" {
    bucket         = "terraform-state-template-example"
    key            = "terraform/infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-dynamodb-example"
    encrypt        = true
  }
}
