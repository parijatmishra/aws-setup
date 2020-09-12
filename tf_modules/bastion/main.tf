data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_iam_instance_profile" "bastion" {
  name = var.name
  role = aws_iam_role.bastion.name
}

resource "aws_iam_role" "bastion" {
  name               = var.name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.bastion_trust_policy.json
  tags               = merge({ "Name" = var.name }, var.common_tags)
}

data "aws_iam_policy_document" "bastion_trust_policy" {
  statement {
    sid = ""
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion.name
}

resource "aws_security_group" "bastion" {
  name        = var.name
  description = "Bastion security group (only SSH access)"
  vpc_id      = var.vpc_id

  // allow incoming SSH connections from anywhere in the VPC
  ingress {
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }

  // allow all outgoing connections
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  revoke_rules_on_delete = true
  
  tags = merge({ "Name" = var.name }, var.common_tags)
}

resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion.id
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = merge({ "Name" = var.name }, var.common_tags)
}
