variable "security_group_id" {
  type = list(string)
}
variable "appname" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_private_subnet_id" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
variable "vpc_id" {
  type = string
}