
#Step 1: Create VPC.
#Minimum required input paramters
#Name Tag:  595-VPC-Public
#CIDR range:  10.10.0.0/16
resource "aws_vpc" "PrivateVPC" {
  cidr_block       = var.private_vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name   = var.private_vpc_name
    Author = var.author
    Team   = var.team
  }

}


#Step 3: Create Private Subnet
#CIDR range:  10.10.2.0/24

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.PrivateVPC.id
  cidr_block = var.private_vpc_priv_subnet_cidr # CIDR block of private subnets

  tags = {
    Name   = var.private_vpc_priv_subnet_name
    Author = var.author
    Team   = var.team
  }
}

#Step 5: Create private routing table
#Add local route
#There is no route to Internet

resource "aws_route_table" "RT" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.PrivateVPC.id
  tags = {
    Name   = var.private_vpc_priv_subnet_rt_name
    Author = var.author
    Team   = var.team
  }
}

#Step 7: Create association between private subnet and private routing table

resource "aws_route_table_association" "RTassociation" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_network_acl" "acl-priv-vpc-subnet-main" {
  vpc_id = aws_vpc.PrivateVPC.id
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0

  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0

  }
  tags = {
    Name = "acl-priv-vpc-subnet-main"
  }
}

resource "aws_network_acl_association" "main-acl" {
  network_acl_id = aws_network_acl.acl-priv-vpc-subnet-main.id
  subnet_id      = aws_subnet.main_subnet.id
}
