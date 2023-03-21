resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  tags = var.tags
  db_subnet_group_name = "default"
}