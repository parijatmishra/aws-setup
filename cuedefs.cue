package config

_#Account: {
    name: string // friendly short name
    id: =~ "\\d{12}" // 12-digit account ID
}

_#Region: {
    code:   "eu-north-1" |
    "ap-south-1" |
    "eu-west-3" |
    "eu-west-2" |
    "eu-west-1" |
    "ap-northeast-3" |
    "ap-northeast-2" |
    "ap-northeast-1" |
    "sa-east-1" |
    "ca-central-1" |
    "ap-southeast-1" |
    "ap-southeast-2" |
    "eu-central-1" |
    "us-east-1" |
    "us-east-2" |
    "us-west-1" |
    "us-west-2"
    azs: ["\(code)a", "\(code)b", "\(code)c"]
}

_#LocalBackend: {
    _key: string
    terraform: backend: local: path: "\(statedir)/\(_key).tfstate"
}

_#AWSProvider: provider: aws: {
    version: "~> 3.0"
    _region: _#Region
    region: _region.code
}

terraform: vars: {}
statedir: string

_accounts: [Name=_]: _#Account & {name: Name}
_accounts: {
    "mparijat-dev": id: "838522581324"
}

// networks
_networks: {
    vpcs: {
        "mparijat-dev": {
            "us-east-1": {
                "vpc01": {
                    // http://www.davidc.net/sites/default/subnets/subnets.html?network=10.2.0.0&mask=16&division=25.f423720
                    cidr: "10.2.0.0/16"
                    public_subnets: ["10.2.0.0/20", "10.2.16.0/20", "10.2.32.0/20"]
                    private_subnets: ["10.2.64.0/19", "10.2.96.0/19", "10.2.128.0/19"]
                }
            }
        }
    }
}

_amis: {
    alinux2: {
        x86_64: {
            "us-east-1": {
                id: "ami-0c94855ba95c71c99"
                ssh_user_name: "ec2-user"
            }
        }
    }
}