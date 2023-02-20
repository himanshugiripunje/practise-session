variable "cidr_block" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "instance_tenancy" {
  type = string
}
variable "public_subnet_cidr_block" {
  type = list(any)
}
variable "private_subnet_cidr_block" {
  type = list(any)
}
variable "env" {
  type = string
}
variable "service_name" {
  type = string
}
variable "availability_zones" {
  type = list(any)
}