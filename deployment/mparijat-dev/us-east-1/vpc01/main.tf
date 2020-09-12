module "vpc01" {
    source = "../../../../tf_modules/simple_vpc"

    name = var.name
    common_tags = var.common_tags
    azs = var.azs
    cidr = var.cidr
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
}
