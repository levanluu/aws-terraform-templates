resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_block)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidr_block, count.index)

  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${local.base_name}-public-subnet-${count.index}"
  }
}
