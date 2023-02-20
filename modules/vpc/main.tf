resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
  tags             = merge(var.tags, tomap({ "Name" = format("%s-%s-vpc", var.service_name, var.env) }))
}
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_block[count.index]
  tags              = merge(var.tags, { "type" = "public" }, tomap({ "Name" = format("%s-%s-public_subnet", var.service_name, var.env) }))
  availability_zone = element(var.availability_zones, count.index)
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  tags              = merge(var.tags, { "type" = "private" }, tomap({ "Name" = format("%s-%s-pivate_subnet", var.service_name, var.env) }))
  availability_zone = element(var.availability_zones, count.index)
}