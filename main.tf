#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-d651b8ac
#
# Your subnet ID is:
#
#     subnet-a2a469e9
#
# Your security group ID is:
#
#     sg-2788a154
#
# Your Identity is:
#
#     NWI-vault-peacock
#
/*
terraform {
	backend "atlas" {
		name = "borgified/training"
	}
}
*/
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

module "example" {
	source = "./example-module"
	command = "echo 'Goodbye World'"
}

variable "num_webs" {
  default = "2"
}

resource "aws_instance" "web" {
  count                  = "${var.num_webs}"
  ami                    = "ami-d651b8ac"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-a2a469e9"
  vpc_security_group_ids = ["sg-2788a154"]

  tags {
    Identity  = "NWI-vault-peacock"
    ManagedBy = "terraform"
    Name      = "web ${count.index + 1}/${var.num_webs}"
  }
}

output "ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "ami" {
  value = "${aws_instance.web.*.ami}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}

