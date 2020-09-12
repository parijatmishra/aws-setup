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
