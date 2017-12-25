provider "aws" {
  region     = "us-east-1"
}

variable "key_name" {}

data "aws_vpc"  "main" {}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow SSH connections"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpn" {
  name        = "vpn-clients"
  description = "Allow VPN clients"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "aws-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "vpn" {
  ami                         = "${data.aws_ami.aws-linux.id}"
  instance_type               = "t2.nano"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.vpn.name}", "${aws_security_group.ssh.name}"]

  tags {
    Name = "VPN Server"
  }
}

output "ip" {
  value = "${aws_instance.vpn.public_ip}"
}
