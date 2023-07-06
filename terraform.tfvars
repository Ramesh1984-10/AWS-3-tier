vpc-cidr            = "10.0.0.0/16"
public_subnet_cidrs = "10.0.1.0/24"
azs                 = ["ap-south-1a", "ap-south-1b"]

private_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]

ssh-location = "0.0.0.0/0"


instance_t = "t2.micro"


key_name = "TEST"

key_name1 = "Tkey"

instance_count = 1