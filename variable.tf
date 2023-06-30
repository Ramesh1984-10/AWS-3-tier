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
  type = string
}

