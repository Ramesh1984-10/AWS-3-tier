# Create Security Group for the Bastion Host aka Jump Box


resource "aws_security_group" "ssh-security-group" {
  name        = "Bastion Security Group"
  description = "Enable SSH access on Port 22"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh-location}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Bastion Security Group"
  }
}

output "private_security_group_id" {
  value = resource.aws_security_group.ssh-security-group.id
}
