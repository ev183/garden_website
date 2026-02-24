# Call the alb module
module "alb" {
  for_each = local.albs
  source   = "../modules/alb"

  alb_name              = each.value.name
  create_security_group = each.value.create_security_group
  subnet_ids            = each.value.subnets
  vpc_id                = each.value.vpc_id
  
  # HTTPS configuration
  enable_https    = lookup(each.value, "enable_https", false)
  certificate_arn = lookup(each.value, "certificate_arn", null)
}

# Reference my public subnets that have been created in the VPC module, so we can use them for the ALB subnets
data "aws_subnet" "public_subnet_1" {
  id = "subnet-08ec88c94e17ac644"
}

data "aws_subnet" "public_subnet_2" {
  id = "subnet-05526a93a1e603e8f"
}

locals {
  # Map of ALBs to create, with keys as ALB names and values as ALB configuration
  albs = {
    garden_website = {
      name                  = "garden-website-alb"
      create_security_group = true
      subnets = [
        data.aws_subnet.public_subnet_1.id,
        data.aws_subnet.public_subnet_2.id
      ]
      vpc_id = data.aws_subnet.public_subnet_1.vpc_id
      
      # HTTPS configuration - Specify cert I requested from ACM.
      enable_https    = true
      certificate_arn = "arn:aws:acm:us-east-1:990991767208:certificate/811852f9-8e0a-45c9-a880-d21cdc265336"
      
      tags = {
        Environment = "production"
        Project     = "garden-website"
      }
    }
  }
}

# ============================================================================
# OUTPUTS
# ============================================================================

output "alb_dns_names" {
  description = "DNS names of all ALBs"
  value = {
    for k, alb in module.alb : k => alb.alb_dns_name
  }
}

output "alb_target_group_arns" {
  description = "Target group ARNs for all ALBs"
  value = {
    for k, alb in module.alb : k => alb.target_group_arn
  }
}

output "alb_security_group_ids" {
  description = "Security group IDs for all ALBs"
  value = {
    for k, alb in module.alb : k => alb.security_group_id
  }
}

output "https_listener_arns" {
  description = "HTTPS listener ARNs for all ALBs"
  value = {
    for k, alb in module.alb : k => alb.https_listener_arn
  }
}