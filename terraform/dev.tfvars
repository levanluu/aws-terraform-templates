project     = "example"
aws_region  = "ap-northeast-1"
domain_name = "example.com"

#VPC
cidr_block                     = "10.0.0.0/16"
public_subnet_cidr_block       = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
rds_security_group_cidr_blocks = ["10.0.0.0/16"]

#RDS
instance_class    = "db.t4g.micro"
db_name           = "example"
username          = "postgres"
password          = "examplePassword"
allocated_storage = 20
