
module "template" {
  source                 = "./launch-template"
  template_private       = var.template_private
  template_public        = var.template_public
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
}
#Create the Autoscaling Group 
resource "aws_autoscaling_group" "new-auto-group-public" {
  name = "auto-scale-public"
  launch_template {
    id      = module.template_public
    version = "$Latest"
  }
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  health_check_type    = "EC2"
  vpc_zone_identifier  = var.vpc_public_subnet_id
  termination_policies = ["OldestInstance"]
}
resource "aws_autoscaling_policy" "autoscaling_policy" {
  autoscaling_group_name    = aws_autoscaling_group.new-auto-group-private.id
  name                      = "autoscaling_policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  tag {
    key                 = "Name"
    value               = "${var.appname}-${var.env}-private-server"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "new-auto-group-private" {
  name = "auto-scale-private"
  launch_template {
    id      = module.template.template_private
    version = "$Latest"
  }
  min_size             = 1
  max_size             = 4
  desired_capacity     = 2
  health_check_type    = "EC2"
  vpc_zone_identifier  = var.vpc_private_subnet_id
  termination_policies = ["OldestInstance"]
  metrics_granularity  = "1Minute"
  tag {
    key                 = "Name"
    value               = "${var.appname}-${var.env}-private-server"
    propagate_at_launch = true
  }
  # Define the SNS topic
  resource "aws_sns_topic" "example" {
    name = "autoscaling-sns-topic"
  }
  # Associate the SNS topic with the Auto Scaling group
  notification_configurations {
    topic_arn = var.sns_topic_arn
    notification_types = [
      "autoscaling:EC2_INSTANCE_LAUNCH",
      "autoscaling:EC2_INSTANCE_TERMINATE",
      "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
      "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
    ]
  }
}
