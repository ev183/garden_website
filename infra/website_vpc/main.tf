module "vpc_subnet" {
  source = "../modules/vpc"
  
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "garden-website-vpc"
  
  subnets = {
    "private-subnet-1a" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    }
    "private-subnet-1b" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  }
}