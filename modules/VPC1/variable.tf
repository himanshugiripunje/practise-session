variable "tags" {
  type = map(string)
}
variable "public_subnet_cidr_block" {
  type = list(string)
}
variable "private_subnet_cidr_block" {
  type = list(string)
}
variable "public_tags" {
  type = map(string)
}
variable "private_tags" {
  type = map(string)
}
variable "pub_availability_zones" {
  type = list(string)
}
variable "pri_availability_zones" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}
variable "cidr_blocks_default" {
  type = string
}
variable "env" {
  type = string
}
variable "security_group" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}