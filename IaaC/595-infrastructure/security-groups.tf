resource "aws_security_group" "ssh-from-anywhere" {
  name        = "ssh-from-anywhere"
  description = "SSH access from anywhere"

  vpc_id = aws_vpc.PublicVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ssh-from-internet"
    Description = "SSH access from internet"
    Author      = var.author
    Team        = var.team
  }
}


resource "aws_security_group" "ssh-from-jumpbox" {
  name        = "ssh-from-jumpbox"
  description = "SSH access from Jump Box"
  vpc_id      = aws_vpc.PrivateVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_vpc_pub_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ssh-from-jumpbox"
    Description = "SSH access from jumpbox"
    Author      = var.author
    Team        = var.team

  }
}
