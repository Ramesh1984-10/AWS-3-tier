variable "vpc-cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR BLOCK"
  type        = string
}

variable "Public_Subnet" {
  default     = "10.0.0.0/24"
  description = "Public Subnet"
  type        = string
}

variable "Private_Subnet" {
  default     = "10.0.1.0/24"
  description = "Private_Subnet"
  type        = string
}


variable "ssh-location" {
  default     = "0.0.0.0/0"
  description = "SSH variable for Bastion"
  type        = string
}

variable "instance_t" {
  default = "t2.micro"
  type    = string
}

variable "key_name" {
  default = "TEST"
  type    = string
}

variable "elastic" {
  default = "elastic_install.sh"
}

variable "key_name1" {
  default = "Tkey"
  type    = string
}