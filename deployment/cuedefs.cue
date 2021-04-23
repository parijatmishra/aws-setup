package config

_outputs: {
    "mparijat-dev": {
        "us-east-1": {
            "vpc01": {
                vpc_id: "vpc-0f10c444cf29366c1"
                vpc_nat_public_ips: ["54.221.172.156"]
                vpc_private_subnet_ids: [
                    "subnet-04b8ea55b57c68e8b",
                    "subnet-0e9e28a969480a6ad",
                    "subnet-0be05f10ca2749b25",
                ]
                vpc_public_subnet_ids: [
                    "subnet-02f41e38773a717e8",
                    "subnet-0f5993f1de2beb0d9",
                    "subnet-0ae9fa2707fef6dc1",
                ]
            }
            "vpc01-bastion": {
                bastion_iam_role: "vpc01-bastion"
                bastion_instance_id: "i-0f2eba056543e9035"
                bastion_public_ip: "3.238.8.155"
                bastion_security_group_id: "sg-05a67a574dd791eb6"
            }
        }
    }
}

_deps: {
    "mparijat-dev": {
        "us-east-1": {
            "vpc01-bastion": {
                vpc_id: _outputs["mparijat-dev"]["us-east-1"]["vpc01"].vpc_id
                subnet_id: _outputs["mparijat-dev"]["us-east-1"]["vpc01"].vpc_public_subnet_ids[0]
            }
        }
    }
}