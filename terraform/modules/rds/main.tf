resource "aws_db_subnet_group" "default" {
  name       = "${local.base_name}-rds-subnet-group"
  subnet_ids = var.subnet_ids
}


resource "aws_db_instance" "default" {
  identifier                          = "${local.base_name}-rds"
  allocated_storage                   = var.allocated_storage
  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  username                            = var.username
  password                            = var.password
  iam_database_authentication_enabled = var.database_authentication_enabled
  skip_final_snapshot                 = "true"
  publicly_accessible                 = "true"
  backup_retention_period             = var.backup_retention_period
  backup_window                       = "07:00-07:30"
  allow_major_version_upgrade         = "true"
  apply_immediately                   = "true"

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = var.security_group_ids
  lifecycle {
    ignore_changes = [password]
  }
}
