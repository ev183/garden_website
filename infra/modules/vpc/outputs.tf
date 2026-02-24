output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [
    for s in values(aws_subnet.subnets) : s.id
    if startswith(s.tags.Name, "private-")
  ]
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

output "vpc_endpoint_ecr_api_id" {
  description = "ID of ECR API VPC endpoint"
  value       = aws_vpc_endpoint.ecr_api.id
}

output "vpc_endpoint_ecr_dkr_id" {
  description = "ID of ECR Docker VPC endpoint"
  value       = aws_vpc_endpoint.ecr_dkr.id
}

output "vpc_endpoint_s3_id" {
  description = "ID of S3 VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value = [
    for name, subnet in aws_subnet.subnets :
    subnet.id
    if !lookup(var.subnets[name], "map_public_ip_on_launch", false)
  ]
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value = [
    for name, subnet in aws_subnet.subnets :
    subnet.id
    if lookup(var.subnets[name], "map_public_ip_on_launch", false)
  ]
}
