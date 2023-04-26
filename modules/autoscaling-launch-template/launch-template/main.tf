resource "aws_launch_template" "launch_template_private" {
  name                   = "application-${var.appname}-${var.env}"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = false
    }
  }
}

#  create launch template 
resource "aws_launch_template" "launch_template_public" {
  name                   = "Webserver-${var.appname}-${var.env}"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  user_data              = local.user_data_base64
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = false
    }
  }
}