module "vpc" {
  source                    = "../modules/VPC1"
  pub_availability_zones    = ["us-east-1a", "us-east-1b"]
  pri_availability_zones    = ["us-east-1c", "us-east-1d"]
  private_tags              = { "Name" = "private_subnet" }
  public_tags               = { "Name" = "public_subnet" }
  private_subnet_cidr_block = ["192.168.3.0/24", "192.168.4.0/24"]
  public_subnet_cidr_block  = ["192.168.1.0/24", "192.168.2.0/24"]
  tags = { "Name" = "INB-project"
    "owner" = "himanshu-module"
  "billing_unit" = "12555464" }
  cidr_blocks_default = "0.0.0.0/0"
  env                 = "dev"
  appname             = "examform"
  security_group      = var.security_group.id
  vpc_cidr_block      = "192.168.0.0/16"
  vpc_id              = var.vpc_id
}
module "autoscaling" {
  source                = "../modules/autoscaling-launch-template"
  env                   = module.vpc.env
  appname               = module.vpc.appname
  security_group        = module.vpc.security_group.id
  image_id              = "ami-09cd747c78a9add63"
  instance_type         = "t2.medium"
  key_name              = "publickey"
  tags                  = module.vpc.tags
  vpc_public_subnet_id  = module.vpc.public_subnet_cidr_block
  vpc_private_subnet_id = module.vpc.private_subnet_cidr_block
}
module "ALB" {
  source                = "../modules/app-loadbalancer"
  security_group_id     = module.vpc.security_group.id
  vpc_private_subnet_id = module.vpc.private_subnet_cidr_block
  tags                  = module.vpc.tags
  vpc_id                = module.vpc.vpc_id
  private_lb_tags = {
    "key"   = "Name"
    "value" = "private_lb"
  }
}
module "RDS" {
  source                = "../modules/RDS"
  allocated_storage     = 10
  max_allocated_storage = 100
  db_name               = "my_private_db"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  username              = "admin"
  password              = "redhat65"
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
  tags                  = module.vpc.tags
}

