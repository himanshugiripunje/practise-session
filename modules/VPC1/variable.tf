variable "tags" {
  type = map(string)
  default = {
    "Name"         = "INB-project"
    "owner"        = "himansu"
    "billing_unit" = "12555464"
  }
}
variable "public_subnet_cidr_block" {
  type    = list(string)
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}
variable "private_subnet_cidr_block" {
  type    = list(string)
  default = ["192.168.3.0/24", "192.168.4.0/24"]
}
variable "public_tags" {
  type = map(string)
  default = {
    "Name" = "public_subnet"
  }
}
variable "private_tags" {
  type = map(string)
  default = {
    "Name" = "private_subnet"
  }
}
variable "pub_availability_zones" {
  type = list(string)
  default = [
    "us-east-1a", "us-east-1b"
  ]
}
variable "pri_availability_zones" {
  type = list(string)
  default = [
    "us-east-1c", "us-east-1d"
  ]
}