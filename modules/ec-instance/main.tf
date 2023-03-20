resource "aws_security_group" "SG" {
  name        = "allow-all-tcp-ports"
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = [module.VPC1.aws_vpc.my_vpc.cidr_block]
}
resource "aws_instance" "nginx" {
  ami_id          = "ami-09cd747c78a9add63"
  instance_type   = "t2.micro"
  key_name        = "public"
  security_groups = []
}