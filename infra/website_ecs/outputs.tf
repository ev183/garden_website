output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "app_sg_id" {
  value = module.vpc.app_sg_id
}
