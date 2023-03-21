output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "security_group" {
  value = aws_security_group.main-sg
}