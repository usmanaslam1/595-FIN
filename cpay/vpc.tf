# Variables

variable "project_name" {
  description = "Name of the project"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for public subnet"
}

variable "private_subnet_a_cidr_block" {
  description = "CIDR block for private subnet A"
}

variable "private_subnet_b_cidr_block" {
  description = "CIDR block for private subnet B"
}

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.project_name} VPC - ${terraform.workspace}"
  }
}

# Create DHCP Options
resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name         = "${var.project_name}-${terraform.workspace}.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "${var.project_name} DHCP Options - ${terraform.workspace}"
  }
}

# Associate DHCP Options with VPC
resource "aws_vpc_dhcp_options_association" "dhcp_options_association" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

# create the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name} IGW - ${terraform.workspace}"
  }
}

# create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name} Public Subnet - ${terraform.workspace}"
  }
}

# Create two private subnets in different availability zones
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_a_cidr_block
  availability_zone = "us-west-2a"

  tags = {
    Name = "${var.project_name} Private Subnet A - ${terraform.workspace}"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_b_cidr_block
  availability_zone = "us-west-2b"

  tags = {
    Name = "${var.project_name} Private Subnet B - ${terraform.workspace}"
  }
}

# create route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_name} Public Route Table - ${terraform.workspace}"
  }
}

# create route table association
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
