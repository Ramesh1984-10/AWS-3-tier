
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
  count  = length(var.subnet_tag)
  vpc_id = aws_vpc.vpc.id
  #cidr_block        = element(var.private_subnet_frontend, count.index)
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = var.subnet_tag[keys(var.subnet_tag)[count.index]]
  }
}

# Private subnet creation
#resource "aws_subnet" "private_app" {
# count  = length(var.private_subnet_app)
# vpc_id = aws_vpc.vpc.id
# #cidr_block        = element(var.private_subnet_app, count.index)
# cidr_block        = var.private_subnet_app[count.index]
# availability_zone = element(var.azs, count.index)
#
# 
#}
#

resource "aws_route_table" "Private-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = var.private_route_t
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  #route {
  #  cidr_block     = "0.0.0.0/0"
  # nat_gateway_id = aws_nat_gateway.gw.id
  #}
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Private-route"
  }
}


# Private Route table aws_route_table_association


resource "aws_route_table_association" "Private-route" {
  count = length(var.subnet_tag)
  #subnet_id      = element(aws_subnet.private[*].id, count.index)
  subnet_id      = aws_subnet.private[count.index].id
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
    "Name" = "Bastion-Host"
  }
}


#Create a new EC2 launch configuration in Private subnet

resource "aws_instance" "App_private-ec2" {
  ami                    = data.aws_ami.amzlinux2.id
  key_name               = var.key_name
  instance_type          = var.instance_t
  count =  4
  subnet_id              = element(aws_subnet.private[*].id, count.index)
  vpc_security_group_ids = [aws_security_group.frontend-SG.id]
  lifecycle {
    create_before_destroy = true
  }
  tags = {
     Name =  var.app_server_tag
  }
}




resource "aws_instance" "Frontend_private-ec2" {
  ami                    = data.aws_ami.amzlinux2.id
  key_name               = var.key_name
  instance_type          = var.instance_t
  count =  2
  subnet_id              = element(aws_subnet.private[*].id, count.index)
  vpc_security_group_ids = [aws_security_group.frontend-SG.id]
  lifecycle {
    create_before_destroy = true
  }
  tags = {
     Name =  var.frontend_server_tag
  }
}



resource "aws_instance" "DB_private-ec2" {
  ami                    = data.aws_ami.amzlinux2.id
  key_name               = var.key_name
  instance_type          = var.instance_t
  count =  2
  subnet_id              = element(aws_subnet.private[*].id, count.index)
  vpc_security_group_ids = [aws_security_group.frontend-SG.id]
  lifecycle {
    create_before_destroy = true
  }
  tags = {
     Name =  var.db_server_tag
  }
}