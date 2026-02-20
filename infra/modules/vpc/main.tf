# ============================================================================
# VPC
# ============================================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true  # Required for VPC endpoints
  enable_dns_support   = true  # Required for VPC endpoints
  
  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

# ============================================================================
# SUBNETS
# ============================================================================

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

# ============================================================================
# INTERNET GATEWAY
# ============================================================================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-igw" }
  )
}

# ============================================================================
# ROUTE TABLES
# ============================================================================

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

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-private-rt" }
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

resource "aws_route_table_association" "private_associations" {
  for_each = {
    for name, subnet in var.subnets :
    name => subnet
    if !lookup(subnet, "map_public_ip_on_launch", false)
  }

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.private.id
}

# ============================================================================
# SECURITY GROUPS
# ============================================================================

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

# Security group for VPC endpoints
resource "aws_security_group" "vpc_endpoints" {
  name_prefix = "${var.vpc_name}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTPS from ECS tasks"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-vpc-endpoints-sg" }
  )
}

# ============================================================================
# VPC ENDPOINTS - For ECS tasks to access ECR without internet
# ============================================================================

# Get private subnet IDs for VPC endpoints
locals {
  private_subnet_ids = [
    for name, subnet in aws_subnet.subnets :
    subnet.id
    if !lookup(var.subnets[name], "map_public_ip_on_launch", false)
  ]
}

# ECR API Endpoint - For authentication and metadata
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-ecr-api-endpoint" }
  )
}

# ECR Docker Endpoint - For pulling container images
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-ecr-dkr-endpoint" }
  )
}

# S3 Gateway Endpoint - For ECR image layers (FREE!)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = merge(
    var.tags,
    { Name = "${var.vpc_name}-s3-endpoint" }
  )
}
