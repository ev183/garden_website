# VPC Resource
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

# Multiple Subnets using for_each
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = lookup(each.value, "map_public_ip_on_launch", false)

  tags = merge(
    var.tags,
    lookup(each.value, "tags", {}),
    {
      Name = each.key
    }
  )
}

resource "aws_security_group" "app_sg" {
  name_prefix = "${var.vpc_name}-app-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-app-sg" }
  )
}
