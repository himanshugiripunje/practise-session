variable "bucket_names" {
  type = list(any)
}
variable "bucket_tags" {
  type = map(string)
}
variable "service_account" {
  type = string
}
variable "user" {
  type = string 
}