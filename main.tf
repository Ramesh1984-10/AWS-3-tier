provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAXI4MP7PYL3IZA67N"
  secret_key = "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"
}

# Create VPC
# terraform aws create vpc

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "Test_vpc"
  }
}


# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway

resource "aws_internet_gateway" "MY_IGW" {
  vpc_id = "vpc-0aa20d1170d9634c8"
  tags = {
    Name = "my_gateway"
  }
}


# Create Public Subnet 1
# terraform aws create subnet

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = "vpc-0aa20d1170d9634c8"
  cidr_block              = "${var.Public_Subnet}"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Pub-Sub-1"
  }
}



# Create Route Table and Add Public Route
# terraform aws create route table


resource "aws_route_table" "Public-route-table" {
  vpc_id = "vpc-0aa20d1170d9634c8"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-012b82c0fbe1c5e36"
  }
  tags = {
    Name = "Pub-route"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table

resource "aws_route_table_association" "public-subnet-route-assocation" {
subnet_id = "subnet-061c36eaf75538843"
route_table_id = "rtb-09d58d1dd3845b4ec"
}

# Create Private Subnet 1
# terraform aws create subnet


resource "aws_subnet" "private-subnet-1" {
vpc_id = "vpc-0aa20d1170d9634c8"
cidr_block = "${var.Private_Subnet}"
availability_zone = "ap-south-1b"
tags = {
Name = "Private-Sub"
}
}

// Dynamically created SSH key pair

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits = 4096
}

resource "local_file" "deployer-key" {
  content = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
  file_permission   = "0400"
}