variable "image_id" {
  type = string
}
variable "key_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "vpc_public_subnet_id" {
  type = list(string)
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
variable "tags" {
  type = string
}
variable "sns_topic_arn" {
  type = string
}