# Simple VPC

Creates a VPC in 3 AZs, with 3 Public Subnets and 3 Private Subnets and a single NAT Gateway. Applies a "Name" tag to each resource. Applies additional supplied tags. Tags the default security group and default route table.

Emits the vpc id, public subnets, private subnets, so these can be used in other plans. Also emits NAT GW public IPs so you can whitelist them in external IP-based firewalls to allow access from systems in this VPC.
