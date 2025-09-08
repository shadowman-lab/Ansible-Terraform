terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.97"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = "us-east-2"
}

data "aws_ami" "rhelami" {
  most_recent      = true
  owners           = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-9.6*HVM*-*Access2*"]
  }
   filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_vpc" "ansiblevpc" {
  cidr_block = "11.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "Ansible-Terraform-VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.ansiblevpc.id
  cidr_block        = "11.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    "Name" = "Ansible-Terraform-Subnet-Public"
  }
}
resource "aws_route_table" "ansible-rt" {
  vpc_id = aws_vpc.ansiblevpc.id
  tags = {
    "Name" = "Ansible-Terraform-RT"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.ansible-rt.id
}

resource "aws_internet_gateway" "ansible-igw" {
  vpc_id = aws_vpc.ansiblevpc.id
  tags = {
    "Name" = "Ansible-Terraform-IG"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.ansible-rt.id
  gateway_id             = aws_internet_gateway.ansible-igw.id
}

resource "aws_security_group" "web-pub-sg" {
  name        = "Ansible_SG"                ### Survey
  description = "allow inbound traffic"
  tags = {
    "Name" = "Ansible-Terraform-SG"
  }
  vpc_id      = aws_vpc.ansiblevpc.id
  ingress {
    description = "from my ip range"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
}
resource "aws_instance" "app-server" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.rhelami.id
  associate_public_ip_address = true
  subnet_id       = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web-pub-sg.id]
  key_name = "Shadowmankey"
  tags = {
      Name = "rhel9app.shadowman.dev"
      owner: "adworjan"
      env: "dev"
      operating_system: "RHEL"
      usage: "shadowmandemos"
      }
}

output "app-server" {
  value = aws_instance.app-server.tags.Name
}
