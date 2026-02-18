# Reference my public subnets
data "aws_subnet" "public_subnet_1" {
  id = "subnet-08ec88c94e17ac644"  # or use filters
}

data "aws_subnet" "public_subnet_2" {
  id = "subnet-05526a93a1e603e8f"  # or use filters
}


module "alb" {
  # Loop through the map of ALBs defined in locals
  for_each = local.albs
  source   = "../modules/alb"
  create_security_group = each.value.create_security_group
  alb_name              = each.value.name
  subnet_ids            = each.value.subnets
  vpc_id                = each.value.vpc_id
}


locals {
  albs = {
    garden_website = {
      name   = "garden-website-alb"
      create_security_group = true
      subnets = [
        data.aws_subnet.public_subnet_1.id,
        data.aws_subnet.public_subnet_2.id
      ]
      vpc_id = data.aws_subnet.public_subnet_1.vpc_id
    }
  }
}
