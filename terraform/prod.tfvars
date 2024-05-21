project     = "example"
aws_region  = "ap-northeast-1"
domain_name = "example.com"

#VPC
cidr_block                     = "172.31.0.0/16"
public_subnet_cidr_block       = ["172.31.0.0/24", "172.31.1.0/24", "172.31.2.0/24"]
rds_security_group_cidr_blocks = ["172.31.0.0/16"]

#RDS
instance_class    = "db.t4g.micro"
db_name           = "example"
username          = "postgres"
password          = "examplePassword"
allocated_storage = 20
