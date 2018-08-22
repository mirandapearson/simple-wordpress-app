provider "aws" {
  region = "us-west-2"
}

# grabs information from provider, makes no changes
data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "name"
    values = ["amzn2-ami-hvm*-x86_64-${var.disk_type}"]
  }
}

# resources reference data to make changes

resource "aws_security_group" "wordpress_default_sg" {
  name        = "wordpress_default_sg"
  description = "Allow ssh and web access."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "wordpress" {
  ami = "${data.aws_ami.amazon-linux.id}"
  instance_type = "${var.instance_type}"
  tags {
    Name = "miranda-wordpress-app"
  }

  key_name = "miranda_macbook_personal"
  security_groups = ["${aws_security_group.wordpress_default_sg.name}"]
}

data "aws_route53_zone" "thegoldenghoul" {
  name         = "thegoldenghoul.com."
}

resource "aws_route53_record" "wordpress_route53_record" {
  zone_id = "${data.aws_route53_zone.thegoldenghoul.zone_id}"
  name    = "blog.${data.aws_route53_zone.thegoldenghoul.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.wordpress.public_ip}"]
}

output "aws ami id" {
  value = "${data.aws_ami.amazon-linux.id}"
}

output "aws ami name" {
  value = "${data.aws_ami.amazon-linux.name}"
}

output "wordpress app public ip" {
  value = "${aws_instance.wordpress.public_ip}"
}
