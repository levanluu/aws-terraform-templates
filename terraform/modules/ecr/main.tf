resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${local.base_name}-ecr"
  image_tag_mutability = var.mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
