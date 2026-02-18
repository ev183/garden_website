# Root module: manage infrastructure resources
data "aws_subnet" "public_subnet_1" {
  id = "subnet-08ec88c94e17ac644"  # or use filters
}

# Root module: manage infrastructure resources
data "aws_subnet" "public_subnet_2" {
  id = "subnet-05526a93a1e603e8f"  # or use filters
}


module "alb" {
  source = "../modules/alb"
  
  alb_name              = "garden-website-alb"
  create_security_group = false
  subnet_ids = [data.aws_subnet.public_subnet_1.id, data.aws_subnet.public_subnet_2.id]
  vpc_id                = data.aws_subnet.public_subnet_1.vpc_id
}