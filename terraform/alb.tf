# =========================
# Application Load Balancer
# =========================

resource "aws_lb" "talentflow" {
  name               = "talentflow-alb-terraform"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name        = "talentflow-alb"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# Target Group
# =========================

resource "aws_lb_target_group" "talentflow" {
  name     = "talentflow-web-tg-tf"
  port     = 80
  protocol = "HTTP"

  vpc_id = aws_vpc.talentflow.id

  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name        = "talentflow-web-tg"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# ALB Listener
# =========================

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.talentflow.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.talentflow.arn
  }
}