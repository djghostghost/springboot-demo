resource "aws_lb" "terraform_handson_alb" {
  name = "terraform-handson-alb"
  internal = false
  load_balancer_type = "application"

  subnets = var.subnets
  enable_deletion_protection = false
  security_groups = [
    var.http_sg]

  tags = var.tags
}

resource "aws_alb_target_group" "alb" {
  name = "alb-target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    interval = 30
    path = "/health"
    port = "8080"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
    matcher = 200
  }

}

resource "aws_alb_target_group_attachment" "alb" {
  port = 8080
  count = length(var.instance_ids)
  target_group_arn = aws_alb_target_group.alb.arn
  target_id = element(var.instance_ids, count.index)
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.terraform_handson_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb.arn
  }

}