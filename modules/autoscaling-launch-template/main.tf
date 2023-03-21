resource "aws_launch_template" "launch_template" {
  name = "scaling-instance-${var.appname}-${var.env}"
  image_id = var.image_id
  instance_type = var.instance_type
   key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]
   user_data   = local.user_data_base64
    block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
      volume_type = "gp2"
      delete_on_termination = false
    }
  }
}
#create the autoscaling group ////
resource "aws_autoscaling_group" "new-auto-group-public" {
  name = "auto-scale-public"
  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  min_size = 1
  max_size = 3
  desired_capacity = 2
  health_check_type = "EC2"
  vpc_zone_identifier = var.vpc_public_subnet_id
  termination_policies = ["OldestInstance"] 
}
resource "aws_autoscaling_policy" "autoscaling_policy" {
  autoscaling_group_name = aws_autoscaling_group.new-auto-group-private.id
  name = "autoscaling_policy"
  policy_type   = "TargetTrackingScaling"
  estimated_instance_warmup = 60
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  tag {
    key = "Name"
    value = "${var.appname}-${var.env}-private-server"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "new-auto-group-private" {
  name = "auto-scale-private"
  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  min_size = 1
  max_size = 4
  desired_capacity = 2
  health_check_type = "EC2"
  vpc_zone_identifier = var.vpc_private_subnet_id
  termination_policies = ["OldestInstance"]
   metrics_granularity = "1Minute"
   tag {
    key = "Name"
    value = "${var.appname}-${var.env}-private-server"
    propagate_at_launch = true
  }
}