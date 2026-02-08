# Call the vpc module
module "vpc" {
  source = "../modules/vpc"

  vpc_name             = local.vpc_config.vpc_name
  vpc_cidr             = local.vpc_config.vpc_cidr
  tags                 = local.vpc_config.tags
  subnets              = local.vpc_config.subnets
}

locals {
  vpc_config = {
    vpc_name  = "website-vpc"
    vpc_cidr  = "10.0.0.0/16"
    tags      = { Environment = "dev" }

    subnets = {
      private-a = {
        cidr_block              = "10.0.11.0/24"
        availability_zone       = "us-east-1a"
        map_public_ip_on_launch = false
        tags = { Tier = "private" }
      }
    }
  }
}
