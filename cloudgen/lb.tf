resource "aws_lb" "main" {
  name = var.lb_name
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [for subnet in aws_subnet.subnets : subnet.id]
}

resource "aws_lb_target_group" "main" {
  name = var.tg_name
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id

  health_check {
    port = 80
    protocol = "HTTP"
    path = "/"
    matcher = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "main" {
  for_each = aws_instance.main

  target_group_arn = aws_lb_target_group.main.arn
  target_id = each.value.id
  port = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}


