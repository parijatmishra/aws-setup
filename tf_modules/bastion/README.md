# Bastion EC2 Instance

Creates an IAM role, IAM instance profile with role attached, a security group, and a "bastion" EC2 instance with the instance profile and security group.

Tags all components with "Name=name" and other "common_tags".

The IAM role has the `AmazonSSMCore` managed policy attached, so authorized IAM users can use Systems Manager Session Manager to login, and to be able to manage the instance via Session Manager (patching etc.).

Emits the bastion EC2 instance ID so you can use AWS Systems Manager Session Manager to log into it, like so:

    aws ssm start-sesion --target *instance-id*

Emits the bastion public IP, so you can access it from outside the VPC. You will need to add ingress rules to its security group.

Emits the security group ID. Not needed if you are accessing the instance via Session Manager. Useful if you want to add ingress rules from IP addresses (e.g. to SSH into the bastion host without using Session Manager, from some known IPs).

Emits the IAM role name, so you can add more permission policies to it.
