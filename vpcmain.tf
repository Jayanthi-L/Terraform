provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-south-1"
}
resource "aws_vpc" "lg_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = "LG-vpc"
  }
}
resource "aws_subnet" "lg_subnet" {
  vpc_id            = aws_vpc.lg_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "ap-south-1a"
  tags = {
    Name = "LG-subnet"
  }
}
resource "aws_internet_gateway" "lg_igw" {
  vpc_id = aws_vpc.lg_vpc.id
  tags = {
    Name = "LG-IGW"
  }
}
resource "aws_route_table" "lg_rt" {
  vpc_id = aws_vpc.lg_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lg_igw.id
  }
  tags = {
    Name = "LG-RT"
  }
}
resource "aws_route_table_association" "lg_rta" {
  subnet_id      = aws_subnet.lg_subnet.id
  route_table_id = aws_route_table.lg_rt.id
}
resource "aws_instance" "lg_instance" {
  ami                         = var.ami
  subnet_id                   = aws_subnet.lg_subnet.id
  count                       = var.number_of_instance
  associate_public_ip_address = "true"
  instance_type               = var.instance_type_map["large"]
  key_name                    = var.key_name
  availability_zone           = "ap-south-1a"
  tags = {
    Name       = "LG-instance"
    Deportment = "DevOps"
  }
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}
variable "subnet_cidr_block" {
  type = string
}
variable "ami" {
  type = string
}
variable "number_of_instance" {
  type = string
}
variable "key_name" {
  type = string
}
variable "instance_type_map" {
  type = map(any)
  default = ({
    small  = "t2.micro"
    medium = "t2.medium"
    large  = "t2.large"
  })
}
