module "bucket_name" {
  source = "../modules/s3bucket"
  bucket_names = [ "buck2.352", "buck5.362", "buck45456" ]
  bucket_tags = {
    "Name" = "myprivate_bucket"
    "owner" =  "cloudbees"
  }
  service_account = "myservice_account"
  user = "himanshu_user"
}

