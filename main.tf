# Create VPC
# terraform aws create vpc

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "Test_vpc"
  }
}


# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway

resource "aws_internet_gateway" "MY_IGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "my_gateway"
  }
}


# Create Public Subnet 1
# terraform aws create subnet

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.Public_Subnet
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Pub-Sub-1"
  }
}



# Create Route Table and Add Public Route
# terraform aws create route table


resource "aws_route_table" "Public-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MY_IGW.id
  }
  tags = {
    Name = "Pub-route"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table

resource "aws_route_table_association" "public-RT-assocation" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.Public-RT.id
}

# Create Private Subnet 1
# terraform aws create subnet


resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Private_Subnet
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Private-Sub"
  }
}

// Dynamically created SSH key pair

resource "aws_key_pair" "TEST" {
  key_name   = "TEST"
  public_key = tls_private_key.Tkey.public_key_openssh
}

resource "tls_private_key" "Tkey" {
  algorithm = "RSA"
}

resource "local_file" "TF_key" {
  content = tls_private_key.Tkey.private_key_pem
  #sensitive_content = tls_private_key.key.private_key_pem
  filename        = "Tkey"
  file_permission = "0400"
}



# Create Security Group for the Bastion Host aka Jump Box
# terraform aws create security group

resource "aws_security_group" "ssh-security-grp" {
  name        = "SSh-security-grp-Bastion"
  description = "Enable SSH connection for Bastion"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "SSH Access"
    from_port   = 0
    to_port     =  0
    protocol    = "-1"
    cidr_blocks = ["${var.ssh-location}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SSh security Group"
  }
}


// Creation of AMI ID in AWS

data "aws_ami" "MY_AMI_ID" {
  most_recent      = true
  #name_regex       = "^myami-\\d{3}"
  owners = ["137112412989"]

  filter {
    name = "name"
    #values = ["myami-*"]
    values = ["al2023-ami-2023.1.20230629.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_id" {
  value = data.aws_ami.MY_AMI_ID.id
}


#Create a new EC2 launch configuration

resource "aws_instance" "public-ec2" {
ami = data.aws_ami.MY_AMI_ID.id
key_name = "${var.key_name}"
instance_type = "${var.instance_t}"
subnet_id = "${aws_subnet.public-subnet-1.id}"
security_groups = ["${aws_security_group.ssh-security-grp.id}"]
associate_public_ip_address = true
lifecycle {
create_before_destroy = true
}


tags = {
"Name" = "EC2-PUBLIC"
}
user_data = file("elastic_install.sh")
}



