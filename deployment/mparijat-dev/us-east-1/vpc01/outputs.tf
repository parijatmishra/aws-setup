output "vpc_id" {
  value = module.vpc01.vpc_id
}

output "vpc_public_subnet_ids" {
  value = module.vpc01.vpc_public_subnet_ids
}

output "vpc_private_subnet_ids" {
  value = module.vpc01.vpc_private_subnet_ids
}

output "vpc_nat_public_ips" {
  value = module.vpc01.vpc_nat_public_ips
}
