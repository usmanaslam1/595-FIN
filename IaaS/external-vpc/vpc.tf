
#Step 1: Create VPC.
#Minimum required input paramters
#Name Tag:  595-VPC-Public
#CIDR range:  10.10.0.0/16
resource "aws_vpc" "PublicVPC" {
  cidr_block       = var.public_vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name   = var.public_vpc_name
    Author = var.author
    Team   = var.team
  }

}


#Step 2: Create Public Subnet
#CIDR range:  10.10.1.0/24

resource "aws_subnet" "pub_subnet" { # Creating Public Subnets
  vpc_id                  = aws_vpc.PublicVPC.id
  cidr_block              = var.public_vpc_pub_subnet_cidr # CIDR block of public subnets
  map_public_ip_on_launch = true
  tags = {
    Name   = var.public_vpc_pub_subnet_name
    Author = var.author
    Team   = var.team
  }

}

#Step 3: Create Private Subnet
#CIDR range:  10.10.2.0/24

resource "aws_subnet" "priv_subnet" {
  vpc_id                  = aws_vpc.PublicVPC.id
  map_public_ip_on_launch = false
  cidr_block              = var.public_vpc_priv_subnet_cidr # CIDR block of private subnets

  tags = {
    Name   = var.public_vpc_priv_subnet_name
    Author = var.author
    Team   = var.team
  }
}



#Step 4: Create public routing table
#Add local route
#Add route to internet via Internet Gateway

resource "aws_route_table" "PublicRT" { # Creating RT for Public Subnet
  vpc_id = aws_vpc.PublicVPC.id

  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name   = var.public_vpc_pub_subnet_rt_name
    Author = var.author
    Team   = var.team
  }
}


#Step 5: Create private routing table
#Add local route
#There is no route to Internet

resource "aws_route_table" "PrivateRT" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.PublicVPC.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
  tags = {
    Name   = var.public_vpc_priv_subnet_rt_name
    Author = var.author
    Team   = var.team
  }
}

#Step 6: Create association between public subnet and public routing table

resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.PublicRT.id
}

#Step 7: Create association between private subnet and private routing table

resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.priv_subnet.id
  route_table_id = aws_route_table.PrivateRT.id
}

#Step 8: Create Internet Gateway

resource "aws_internet_gateway" "IGW" { # Creating Internet Gateway
  vpc_id = aws_vpc.PublicVPC.id         # vpc_id will be generated after we create VPC
  tags = {
    Name   = var.public_vpc_igw_name
    Author = var.author
    Team   = var.team
  }
}

#Step 9: Obtain Elastic IP
resource "aws_eip" "nateIP" {
  vpc = true
  tags = {
    Name   = var.public_vpc_natgw_eip_name
    Author = var.author
    Team   = var.team
  }
}

#Step 10: Obtain Elastic IP
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.priv_subnet.id
  tags = {
    Name   = var.public_vpc_nat_gw_name
    Author = var.author
    Team   = var.team
  }
}
