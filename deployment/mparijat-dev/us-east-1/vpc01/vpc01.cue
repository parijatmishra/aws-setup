package config

statedir: "../../../state"

let Name = "vpc01"
let vpc_net = _networks.vpcs["mparijat-dev"]["us-east-1"]["vpc01"]

terraform: {
    provider: _#AWSProvider & {
        provider: aws: _region: region
    }

    backend: _#LocalBackend & {
        _key: "\(account.name).\(region.code).\(Name)"
    }
    vars: {
        name: Name
        common_tags: {
            Application: Name
        }
        azs: region.azs
        cidr: vpc_net.cidr
        public_subnets: vpc_net.public_subnets
        private_subnets: vpc_net.private_subnets
    }
}
