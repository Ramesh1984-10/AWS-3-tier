
provider "aws" {
  region = "ap-south-1"
}


# Create VPC
# terraform aws create vpc

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "Test_VPC"
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
  cidr_block              = var.public_subnet_cidrs
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
    Name = "Public-route"
  }
}


# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table

resource "aws_route_table_association" "public-RT-assocation" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public-subnet-1[*].id, count.index)
  route_table_id = aws_route_table.Public-RT.id
}



# Private subnet creation
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}



resource "aws_route_table" "Private-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  tags = {
    Name = "Private-route"
  }
}


# Private Route table aws_route_table_association


resource "aws_route_table_association" "Private-route" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.Private-RT.id
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


#Create a new EC2 launch configuration in PUBLIC subnet

resource "aws_instance" "public-ec2" {
  ami                         = data.aws_ami.amzlinux2.id
  key_name                    = var.key_name
  instance_type               = var.instance_t
  subnet_id                   = aws_subnet.public-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.ssh-security-group.id]
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    "Name" = "EC2-PUBLIC"
  }
}
