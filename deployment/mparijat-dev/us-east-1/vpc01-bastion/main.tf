module "bastion" {
    source = "../../../../tf_modules/bastion"

    name = var.name
    vpc_id = var.vpc_id
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    key_name =  var.key_name
    common_tags = var.common_tags
}