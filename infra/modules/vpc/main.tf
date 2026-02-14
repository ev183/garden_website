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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-igw" }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-public-rt" }
  )
}

resource "aws_route_table_association" "public_associations" {
  for_each = {
    for name, subnet in var.subnets :
    name => subnet
    if lookup(subnet, "map_public_ip_on_launch", false)
  }

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public.id
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
