
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

resource "aws_subnet" "priv_subnet" {
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

resource "aws_route_table" "PrivateRT" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.PrivateVPC.id
  tags = {
    Name   = var.private_vpc_priv_subnet_rt_name
    Author = var.author
    Team   = var.team
  }
}

#Step 7: Create association between private subnet and private routing table

resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.priv_subnet.id
  route_table_id = aws_route_table.PrivateRT.id
}
