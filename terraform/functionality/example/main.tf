resource "null_resource" "example_resource" {
  provisioner "local-exec" {
    command = "echo ${var.account_id}; echo ${var.aws_region}; echo ${var.project}; echo ${var.route53_zone_id}"
  }
}
