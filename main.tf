provider "aws" {
  region = var.aws_region
}

data "aws_ami" "i" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Deep Learning AMI GPU PyTorch 2.0.? (Amazon Linux 2) ????????"]
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "dl-instance-key"
  public_key = file("dl-instance-key.pub")
}


resource "aws_security_group" "deepLearning" {
  name        = "${var.service}-${uuid()}"
  description = "Security group for ${title(var.service)}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 8888
    to_port     = 8898
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = title(var.service)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.service}-${uuid()}"
    Service   = "${title(var.service)}"
    Terraform = "true"
  }
}

resource "aws_instance" "deepLearning" {
  ami                    = "${data.aws_ami.i.id}"
  availability_zone      = var.availability_zone
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = ["${aws_security_group.deepLearning.id}"]

  tags = {
    Name      = "${title(var.service)}-${timestamp()}"
    Service   = "${title(var.service)}"
    Terraform = "true"
  }

}

terraform {
  backend "local" {
  }
}