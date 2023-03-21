resource "aws_lb" "ALB" {
    name = format("%s-%s-%s", var.appname, var.env, "ALB")
    internal           = true
    load_balancer_type = "application"
    security_groups    = [var.security_group_id] 
    subnets = var.vpc_private_subnet_id
    enable_deletion_protection = false
    tags    = var.tags
}
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = 80
  protocol          = http

  default_action {
    target_group_arn = aws_lb_target_group.lb-tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "lb-tg" {
  name_prefix      = 
  port             = 8080
  protocol         = tcp
  vpc_id           = var.vpc_id

  health_check {
    path                = var.type == "application" ? "/" : null
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = var.type == "application" ? "HTTP" : "TCP"
    port                = var.type == "application" ? 80 : 80
  }
}

resource "aws_autoscaling_attachment" "lb_asg_attachment" {
  autoscaling_group_name = var.autoscaling_group_name 
  lb_target_group_arn   = aws_lb_target_group.lb-tg.arn
  depends_on = [aws_lb_target_group.lb-tg]
}


