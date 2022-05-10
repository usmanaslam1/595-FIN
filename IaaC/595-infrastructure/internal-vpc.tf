
resource "aws_vpc" "PrivateVPC" {
  cidr_block       = var.private_vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name   = var.private_vpc_name
    Author = var.author
    Team   = var.team
  }

}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.PrivateVPC.id
  cidr_block = var.private_vpc_priv_subnet_cidr

  tags = {
    Name   = var.private_vpc_priv_subnet_name
    Author = var.author
    Team   = var.team
  }
}


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
    Name   = "acl-priv-vpc-subnet-main"
    Author = var.author
    Team   = var.team

  }
}

resource "aws_network_acl_association" "main-acl" {
  network_acl_id = aws_network_acl.acl-priv-vpc-subnet-main.id
  subnet_id      = aws_subnet.main_subnet.id
}


resource "aws_route" "peering-route-2" {
  route_table_id            = aws_route_table.RT.id
  destination_cidr_block    = var.public_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
  depends_on                = [aws_route_table.RT]
}

resource "aws_route" "peering-main-route-2" {
  route_table_id            = aws_vpc.PrivateVPC.default_route_table_id
  destination_cidr_block    = var.public_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}
