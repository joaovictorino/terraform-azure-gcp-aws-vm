provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc-sample" {
  cidr_block = "10.0.0.0/16"

  tags = {
    project = "aula"
  }
}

resource "aws_internet_gateway" "igw-sample" {
  vpc_id = aws_vpc.vpc-sample.id

  tags = {
    project = "aula"
  }
}

resource "aws_route" "rt-sample" {
  route_table_id         = aws_vpc.vpc-sample.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-sample.id
}

resource "aws_subnet" "sub-sample" {
  vpc_id                  = aws_vpc.vpc-sample.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    project = "aula"
  }
}

resource "aws_security_group" "sg-sample" {
  name   = "sg_sample"
  vpc_id = aws_vpc.vpc-sample.id

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

resource "aws_key_pair" "key-sample" {
  key_name   = "key-sample"
  public_key = file("id_rsa.pub")

  tags = {
    project = "aula"
  }
}

resource "aws_instance" "vm-sample" {
  instance_type          = "t2.micro"
  ami                    = "ami-053b0d53c279acc90"
  key_name               = aws_key_pair.key-sample.id
  vpc_security_group_ids = [aws_security_group.sg-sample.id]
  subnet_id              = aws_subnet.sub-sample.id

  tags = {
    project = "aula"
  }
}

output "public_ip_aws" {
  value = aws_instance.vm-sample.public_ip
}