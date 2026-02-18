# SG for inbound into ALB
resource "aws_security_group" "alb_sg" {
  count       = var.create_security_group ? 1 : 0  # ← Creates 1 or 0 SGs
  name        = "${var.alb_name}-sg"
  description = "Security group for ${var.alb_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.alb_name}-sg"
  }
}

resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups    = var.create_security_group ? [aws_security_group.alb_sg[0].id] : var.security_group_ids
  
  subnets            = var.subnet_ids

  tags = {
    Environment = "production"
  }
}

# Target Group
resource "aws_lb_target_group" "main" {
  name        = "${var.alb_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"  # ← Important for ECS tasks (Fargate/awsvpc mode)

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"  # nginx default health check path
    protocol            = "HTTP"
    matcher             = "200"
  }

  deregistration_delay = 30  # Faster draining for containers

  tags = {
    Name        = "${var.alb_name}-tg"
    Environment = "production"
  }
}

# Listener on port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = {
    Environment = "production"
  }
}