variable "vpc-cidr" {
  description = "CIDR Of VPC"
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR values"

}

variable "azs" {
  description = "Availability Zones"
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDR values"
}

variable "ssh-location" {
  description = "SSH variable for Bastion"
}

variable "instance_t" {
  description = "Ec2 instance type"
}

variable "key_name" {
  description = "Public Key Name"
}



variable "key_name1" {
  description = "Private Key Name"
}



variable "elastic" {
  default = "elastic_install.sh"
}



variable "instance_count" {
  description = "Ec2 instance Count"
}

variable "public_route" {
  type        = string
  description = "Public Route CIDR"
  default     = "0.0.0.0/0"
}


variable "private_route" {
  type        = string
  description = "Private Route CIDR"
  default     = "0.0.0.0/0"
}
