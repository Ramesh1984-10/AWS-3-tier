vpc-cidr            = "10.0.0.0/16"
public_subnet_cidrs = "10.0.1.0/24"
azs                 = ["ap-south-1a", "ap-south-1b"]

private_subnet_cidr = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]


subnet_tag = {
  db       = "Database Subnet"
  app      = "Application Subnet"
  frontend = "Frontend Subnet"
}

server_tag = {
  db       = "Database Subnet"
  app      = "Application Subnet"
  frontend = "Frontend Subnet"
}



db_server_tag = "Database Server"
app_server_tag  = "Application Server"
frontend_server_tag = "Frontend Server"


private_route_t = "0.0.0.0/0"

ssh-location = "0.0.0.0/0"


instance_t = "t2.micro"


key_name = "TEST"

key_name1 = "Tkey"
