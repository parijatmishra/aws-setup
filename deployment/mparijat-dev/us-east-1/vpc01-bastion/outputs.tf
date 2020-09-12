output "bastion_instance_id" {
  value = module.bastion.bastion_instance_id
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "bastion_security_group_id" {
  value = module.bastion.bastion_security_group_id
}

output "bastion_iam_role" {
  value = module.bastion.bastion_iam_role
}

output "bastion_ssh_config" {
  value = <<-EOT

  Host ${var.name}
      HostName ${module.bastion.bastion_instance_id}
      User ${var.ssh_user_name}
      IdentityFile ~/.ssh/${var.key_name}
      ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
  EOT
}

