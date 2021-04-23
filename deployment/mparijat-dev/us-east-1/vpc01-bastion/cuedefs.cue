package config

statedir: "../../../state"
let Name = "vpc01-bastion"

terraform: {
    provider: _#AWSProvider & {
        provider: aws: _region: region
    }

    backend: _#LocalBackend & {
        _key: "\(account.name).\(region.code).\(Name)"
    }
    vars: {
        name: Name
        vpc_id: _deps[account.name][region.code][Name].vpc_id
        subnet_id: _deps[account.name][region.code][Name].subnet_id
        ami: _amis.alinux2.x86_64[region.code].id
        ssh_user_name: _amis.alinux2.x86_64[region.code].ssh_user_name
        instance_type: "t3a.micro"
        key_name: "general1"
        common_tags: {
            Application: Name
        }
    }
}
