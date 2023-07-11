vpc-cidr            = "10.0.0.0/16"
public_subnet_cidrs = "10.0.1.0/24"
azs                 = ["ap-south-1a", "ap-south-1b"]

private_subnet_cidr = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]

instance_counts  = [2, 1, 1, 1, 1, 1]



subnet_tag = {
  db       = "Database Subnet"
  app      = "Application Subnet"
  frontend = "Frontend Subnet"
  db1 = "Database Subnet 2"
  app1 = "Application Subnet 2"
  frontend1 = "Frontend Subnet 2"
}

server_tag = {
  db       = "Database Server"
  app      = "Application Server"
  frontend = "Frontend Server"
  db2       = "Database Server 2"
  app2      = "Application Server 2"
  frontend2 = "Frontend Server 2"
}


private_route_t = "0.0.0.0/0"

ssh-location = "0.0.0.0/0"


instance_t = "t2.micro"


key_name = "TEST"

key_name1 = "Tkey"
