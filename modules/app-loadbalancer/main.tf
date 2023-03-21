resource "aws_lb" "ALB" {
  name                       = format("%s-%s-%s", var.appname, var.env, "ALB")
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [var.security_group_id]
  subnets                    = var.vpc_private_subnet_id
  enable_deletion_protection = false
  tags                       = var.private_lb_tags
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
resource "aws_lb_listener_rule" "static" {
  listener_arn = var.listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    field  = "path-pattern"
    values = ["/student/*"]
  }
}

resource "aws_lb_target_group" "lb-tg" {
  port     = 8080
  protocol = tcp
  vpc_id   = var.vpc_id

  health_check {
    path                = "/student/"
    interval            = 30
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = tcp
    port                = 8080
  }
}

resource "aws_autoscaling_attachment" "lb_asg_attachment" {
  autoscaling_group_name = var.autoscaling_group_name
  lb_target_group_arn    = aws_lb_target_group.lb-tg.arn
  depends_on             = [aws_lb_target_group.lb-tg]
}


