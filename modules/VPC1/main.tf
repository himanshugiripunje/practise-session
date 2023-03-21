resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags             = var.tags
}
#create 2 public subnets now 
resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.my_vpc.id
  count             = length(var.public_subnet_cidr_block)
  cidr_block        = var.public_subnet_cidr_block[count.index]
  availability_zone = var.pub_availability_zones[count.index]
  tags              = merge(var.tags, var.public_tags)
  map_public_ip_on_launch = true
}

#create 2 private subnets 
resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.my_vpc.id
  count             = length(var.private_subnet_cidr_block)
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = var.pri_availability_zones[count.index]
  tags              = merge(var.tags, var.private_tags)
}
#create igw
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.my_vpc.id
}

#create route table and stick igw 
resource "aws_route_table" "grt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}
##igw - route association to public_subnet
resource "aws_route_table_association" "a" {
  count          = length(var.private_subnet_cidr_block)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.grt.id
}

#EIP
resource "aws_eip" "eip" {
  vpc = true
}

#NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnets[0].id
}

output "nat_gateway_ip" {
  value = aws_eip.eip.address
}
#nat  //////////////////////////////////////
resource "aws_route_table" "nrt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
#nat association to private
# //////////////////////////////////////////////////////
resource "aws_route_table_association" "nat_route" {
  count          = length(var.private_subnet_cidr_block)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.nrt.id
}
///// security-groups-rules-for infrastructure ////
resource "aws_security_group" "main-sg" {
  name   = "main-sg"
  vpc_id = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = [8080, 22, 80, 3306]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.cidr_blocks_default]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_blocks_default]
  }

  tags = {
    "Name" = "main-sg"
  }
}
