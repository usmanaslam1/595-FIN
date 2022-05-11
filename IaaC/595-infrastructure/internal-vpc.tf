
###############VPC####################
resource "aws_vpc" "PrivateVPC" {
  cidr_block       = var.private_vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name   = var.private_vpc_name
    Author = var.author
    Team   = var.team
  }

}

###############Subnets####################

##Public Subnet
resource "aws_subnet" "vpc2_pub_subnet" {
  vpc_id                  = aws_vpc.PrivateVPC.id
  cidr_block              = var.private_vpc_pub_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name   = var.private_vpc_pub_subnet_name
    Author = var.author
    Team   = var.team
  }
}

### Public Routing Table
#
resource "aws_route_table" "vcp2-pub-rt" {
  vpc_id = aws_vpc.PrivateVPC.id

  route {
    cidr_block = var.default_route_cidr
    gateway_id = aws_internet_gateway.IGW-vpc2.id
  }

  tags = {
    Name   = var.private_vpc_pub_subnet_rt_name
    Author = var.author
    Team   = var.team
  }
}


resource "aws_route_table_association" "vpc2_pub_subnet-vcp2-pub-rt" {
  subnet_id      = aws_subnet.vpc2_pub_subnet.id
  route_table_id = aws_route_table.vcp2-pub-rt.id
}

##Private Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.PrivateVPC.id
  cidr_block = var.private_vpc_priv_subnet_cidr

  tags = {
    Name   = var.private_vpc_priv_subnet_name
    Author = var.author
    Team   = var.team
  }
}

### Private Routing Table
#
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.PrivateVPC.id

  tags = {
    Name   = var.private_vpc_priv_subnet_rt_name
    Author = var.author
    Team   = var.team
  }
}


resource "aws_route_table_association" "RTassociation" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.RT.id
}


###############Network ACLs####################
### Private Network ACL
#
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
    Name   = "VPC1: ACL Inside Network"
    Author = var.author
    Team   = var.team


  }
}

resource "aws_network_acl_association" "main-acl" {
  network_acl_id = aws_network_acl.acl-priv-vpc-subnet-main.id
  subnet_id      = aws_subnet.main_subnet.id
}

### Public Network ACL
#
resource "aws_network_acl" "acl-priv-vpc-subnet-pub" {
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
    Name   = "VPC2: ACL DMZ Network"
    Author = var.author
    Team   = var.team


  }
}

resource "aws_network_acl_association" "vpc2-pub-acl" {
  network_acl_id = aws_network_acl.acl-priv-vpc-subnet-pub.id
  subnet_id      = aws_subnet.vpc2_pub_subnet.id
}

###############Internet Gateay####################
resource "aws_internet_gateway" "IGW-vpc2" { # Creating Internet Gateway
  vpc_id = aws_vpc.PrivateVPC.id             # vpc_id will be generated after we create VPC
  tags = {
    Name   = var.private_vpc_igw_name
    Author = var.author
    Team   = var.team
  }
}


###############NAT Gateway####################

#Elastic IP address for Nat Gateway
resource "aws_eip" "nateIP-VPC2" {
  vpc = true
  tags = {
    Name   = var.private_vpc_natgw_eip_name
    Author = var.author
    Team   = var.team
  }
}
#Nat Gateway
resource "aws_nat_gateway" "NATgw-vpc2" {
  allocation_id = aws_eip.nateIP-VPC2.id
  subnet_id     = aws_subnet.vpc2_pub_subnet.id
  tags = {
    Name   = var.private_vpc_nat_gw_name
    Author = var.author
    Team   = var.team
  }
}



### VPC Peering Routes
#

resource "aws_route" "peering-route-2" {
  route_table_id            = aws_route_table.RT.id
  destination_cidr_block    = var.public_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}

resource "aws_route" "vpc2-inside-network-via-ngw" {
  route_table_id         = aws_route_table.RT.id
  destination_cidr_block = var.default_route_cidr
  nat_gateway_id         = aws_nat_gateway.NATgw-vpc2.id
}


resource "aws_route" "peering-main-route-2" {
  route_table_id            = aws_vpc.PrivateVPC.default_route_table_id
  destination_cidr_block    = var.public_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}
