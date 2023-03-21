resource "aws_s3_bucket" "name" {
  count = length(var.bucket_names)
  bucket = element(var.bucket_names, count.index)
  tags = merge(var.bucket_tags, {"Env" = "iata-prodenv"}, tomap({"Name" = format("%s-%s-%s-ID", var.service_account, var.user)}))
}