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