# Creating NAT Gateway
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.eip-for-Nat-Gateway.id
  subnet_id     = aws_subnet.public-subnet-1.id
}
