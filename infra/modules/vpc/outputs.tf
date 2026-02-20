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
