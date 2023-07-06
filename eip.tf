# Creating EIP
resource "aws_eip" "eip-for-Nat-Gateway" {
  vpc = true
}
