
###############VPC####################

resource "aws_vpc" "PublicVPC" {
  cidr_block       = var.public_vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name   = var.public_vpc_name
    Author = var.author
    Team   = var.team
  }
}


###############Subnets####################

##Public Subnet
resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.PublicVPC.id
  cidr_block              = var.public_vpc_pub_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name   = var.public_vpc_pub_subnet_name
    Author = var.author
    Team   = var.team
  }

}

### Pubic Routing Table
#There is a default route to internet via Internet Gateway
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.PublicVPC.id
  route {
    cidr_block = var.default_route_cidr
    gateway_id = aws_internet_gateway.IGW.id
  }
  route {
    cidr_block                = var.private_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
  }

  tags = {
    Name   = var.public_vpc_pub_subnet_rt_name
    Author = var.author
    Team   = var.team
  }
}
#Attach routing table to subnet
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.PublicRT.id
}


##Private Subnet
resource "aws_subnet" "priv_subnet" {
  vpc_id     = aws_vpc.PublicVPC.id
  cidr_block = var.public_vpc_priv_subnet_cidr

  tags = {
    Name   = var.public_vpc_priv_subnet_name
    Author = var.author
    Team   = var.team
  }
}

### Pubic Routing Table
#There is a default one-way route to internet via Nat Gateway
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.PublicVPC.id
  route {
    cidr_block     = var.default_route_cidr
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
  tags = {
    Name   = var.public_vpc_priv_subnet_rt_name
    Author = var.author
    Team   = var.team
  }
}

#Attach routing table to subnet
resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.priv_subnet.id
  route_table_id = aws_route_table.PrivateRT.id
}


###############Internet Gateay####################
resource "aws_internet_gateway" "IGW" { # Creating Internet Gateway
  vpc_id = aws_vpc.PublicVPC.id         # vpc_id will be generated after we create VPC
  tags = {
    Name   = var.public_vpc_igw_name
    Author = var.author
    Team   = var.team
  }
}

#Elastic IP address for Nat Gateway
resource "aws_eip" "nateIP" {
  vpc = true
  tags = {
    Name   = var.public_vpc_natgw_eip_name
    Author = var.author
    Team   = var.team
  }
}
#Nat Gateway
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.pub_subnet.id
  tags = {
    Name   = var.public_vpc_nat_gw_name
    Author = var.author
    Team   = var.team
  }
}


###############Network ACLs####################
#Stateless firewall rules
resource "aws_network_acl" "acl-pub-vpc-subnet-external-1" {
  vpc_id = aws_vpc.PublicVPC.id
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
    Name   = "VPC1: ACL DMZ Network"
    Author = var.author
    Team   = var.team
  }
}
resource "aws_network_acl" "acl-pub-vpc-subnet-internal-1" {
  vpc_id = aws_vpc.PublicVPC.id
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

resource "aws_network_acl_association" "external-1-acl" {
  network_acl_id = aws_network_acl.acl-pub-vpc-subnet-external-1.id
  subnet_id      = aws_subnet.pub_subnet.id
}
resource "aws_network_acl_association" "internal-1-acl" {
  network_acl_id = aws_network_acl.acl-pub-vpc-subnet-internal-1.id
  subnet_id      = aws_subnet.priv_subnet.id
}



###############VPC Peering Connection####################

resource "aws_vpc_peering_connection" "vpc-peering" {
  peer_vpc_id = aws_vpc.PrivateVPC.id
  vpc_id      = aws_vpc.PublicVPC.id
  auto_accept = true

  tags = {
    Name   = "VPC Peering between public and private VPCs"
    Author = var.author
    Team   = var.team
  }
}

#resource "aws_route" "peering-route-public-subnet" {
#  route_table_id            = aws_route_table.PublicRT.id
#  destination_cidr_block    = var.private_vpc_cidr
#  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
#}
resource "aws_route" "peering-route-public-vpc-main" {
  route_table_id            = aws_vpc.PublicVPC.default_route_table_id
  destination_cidr_block    = var.private_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}
