# SG for inbound into ALB
resource "aws_security_group" "alb_sg" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.alb_name}-sg"
  description = "Security group for ${var.alb_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.alb_name}-sg"
  }
}

# Create the ALB and related resources for each ALB defined in the local.albs map
# We use a for_each loop to iterate over the map and create resources for each ALB
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  
  # We use the security group we just created if create_security_group is true, otherwise we use the provided security group IDs
  security_groups = var.create_security_group ? [aws_security_group.alb_sg[0].id] : var.security_group_ids
  subnets         = var.subnet_ids

  tags = {
    Environment = "production"
  }
}

# Create target group and listeners for each ALB
# We use conditional logic to create the HTTPS listener only if enable_https is true, and to redirect HTTP to HTTPS if enable_https is true
resource "aws_lb_target_group" "main" {
  name        = "${var.alb_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = {
    Name        = "${var.alb_name}-tg"
    Environment = "production"
  }
}

# HTTP Listener - Redirect to HTTPS if enabled, otherwise forward
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = var.enable_https ? "redirect" : "forward"

    # Redirect to HTTPS
    dynamic "redirect" {
      for_each = var.enable_https ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    # Forward to target group if no HTTPS
    target_group_arn = var.enable_https ? null : aws_lb_target_group.main.arn
  }

  tags = {
    Environment = "production"
  }
}

# HTTPS Listener - Only created if HTTPS is enabled
resource "aws_lb_listener" "https" {
  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = {
    Environment = "production"
  }
}