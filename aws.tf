provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc-aula" {
  cidr_block = "10.0.0.0/16"

  tags = {
    project = "aula"
  }
}

resource "aws_internet_gateway" "igw-aula" {
  vpc_id = aws_vpc.vpc-aula.id

  tags = {
    project = "aula"
  }
}

resource "aws_route" "rt-aula" {
  route_table_id         = aws_vpc.vpc-aula.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-aula.id
}

resource "aws_subnet" "sub-aula" {
  vpc_id                  = aws_vpc.vpc-aula.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    project = "aula"
  }
}

resource "aws_security_group" "sg-aula" {
  name   = "sg_aula"
  vpc_id = aws_vpc.vpc-aula.id

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
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    project = "aula"
  }
}

resource "aws_key_pair" "key-aula" {
  key_name   = "key-aula"
  public_key = file("id_rsa.pub")

  tags = {
    project = "aula"
  }
}

resource "aws_instance" "vm-aula" {
  instance_type          = "t2.micro"
  ami                    = "ami-04751c628226b9b59"
  key_name               = aws_key_pair.key-aula.id
  vpc_security_group_ids = [aws_security_group.sg-aula.id]
  subnet_id              = aws_subnet.sub-aula.id

  tags = {
    project = "aula"
  }
}

output "public_ip_aws" {
  value = aws_instance.vm-aula.public_ip
}