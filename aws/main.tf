provider "aws" {
  # Credentials are read from ~/.aws/credentials
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/16"
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.main.id
}

resource "aws_security_group" "base" {
  name        = "base"
  description = "Allow all incoming traffic from same security group and all outgoing traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    self        = true
    description = "Allow all incoming traffic from same security group"
  }
  # The AWS provider removes the default egress rule, so it has to be redefined
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outgoing traffic"
  }
}

resource "aws_security_group" "http-ssh" {
  name        = "http-ssh"
  description = "Allow incoming traffic to port 80 from everywhere and port 22 from a specific IP address"
  vpc_id      = aws_vpc.main.id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP traffic from everywhere"
  }
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.localhost_ip}/32"]
    description = "Allow incoming SSH traffic from a specific IP address"
  }
}

data "local_file" "public_key" {
  filename = pathexpand(var.public_key_file)
}

# Performs 'ImportKeyPair' API operation (not 'CreateKeyPair')
resource "aws_key_pair" "main" {
  key_name_prefix = "example-infra-terraform-"
  public_key      = data.local_file.public_key.content
}

data "aws_ami" "ubuntu" {
  owners = ["099720109477"] # AWS account ID of Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  most_recent = true
}

resource "aws_instance" "instances" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids      = [aws_security_group.base.id, aws_security_group.http-ssh.id]
}
