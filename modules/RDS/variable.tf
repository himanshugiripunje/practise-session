variable "instance_class" {
  type = string
}

variable "vpc_private_subnet_id" {
  type = list(string)
}
variable "security_group_id" {
  type = list(string)
}
variable "appname" {
  type = string
}
variable "env" {
  type = string
}
variable "allocated_storage" {
  type = number
}
variable "max_allocated_storage" {
  type = number
}
variable "db_name" {
  type = list(any)
}
variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "instance_class" {
  type = string
}
variable "skip_final_snapshot" {
  type = bool
}
variable "username" {
  type = string
}
variable "password" {
  type = string
}
variable "parameter_group_name" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}