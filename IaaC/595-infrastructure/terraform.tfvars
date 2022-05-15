region                          = "us-west-1"
public_vpc_cidr                 = "10.10.0.0/16"
public_vpc_name                 = "595-VPC-1"
public_vpc_pub_subnet_cidr      = "10.10.1.0/24"
public_vpc_pub_subnet_2_cidr    = "10.10.3.0/24"
public_vpc_pub_subnet_name      = "VPC-1: DMZ Network"
public_vpc_pub_subnet_2_name    = "VPC-1: Network in second AZ"
public_vpc_priv_subnet_cidr     = "10.10.2.0/24"
public_vpc_priv_subnet_name     = "VPC-1: Inside Network"
public_vpc_pub_subnet_rt_name   = "VPC-1: RT DMZ Network"
public_vpc_pub_subnet_rt_2_name = "VPC-1: RT Network in second AZ"
public_vpc_priv_subnet_rt_name  = "VPC-1: RT Inside Network"
public_vpc_igw_name             = "VPC-1: Internet Gateway"
public_vpc_nat_gw_name          = "VPC-1: Nat Gateway"
public_vpc_natgw_eip_name       = "Elastic IP for VPC-1: Nat Gateway"
private_vpc_natgw_eip_name      = "Elastic IP for VPC-2: Nat Gateway"
private_vpc_cidr                = "10.20.0.0/16"
private_vpc_name                = "595-VPC-2"
private_vpc_priv_subnet_cidr    = "10.20.2.0/24"
private_vpc_pub_subnet_cidr     = "10.20.1.0/24"
private_vpc_igw_name            = "VPC-2: Internet Gateway"
private_vpc_priv_subnet_name    = "VPC-2: Inside Network"
private_vpc_pub_subnet_name     = "VPC-2: DMZ Network"
private_vpc_priv_subnet_rt_name = "VPC-2: RT Inside Network"
private_vpc_pub_subnet_rt_name  = "VPC-2: RT DMZ Network"
private_vpc_nat_gw_name         = "VPC-2: Nat Gateway"

default_route_cidr = "0.0.0.0/0"
author             = "Usman Aslam"
team               = "John Afreen Jawad Usman"

##############


keypair_name = "aws_keypair"
keyfile_name = "aws_keypair.pem"
#keypair_name = "princeton-key"
#keyfile_name = "princeton-key.pem"

#Instance types
jump_box_instance_type     = "t2.micro"
elk_box_instance_type      = "t2.medium"
nginx_kibana_instance_type = "t2.micro"
wordpress_instance_type    = "t2.small"

#AMIs
elk_box_ami      = "ami-0006957e570b16592"
jump_box_ami     = "ami-02eb1685adb70eb60"
nginx_kibana_ami = "ami-09c4aec627a4f0b92"
wordpress_ami    = "ami-0a0f666a312b29931"

##IP addresses
ip_jump_box            = "10.10.1.10"
ip_wordpress_instance1 = "10.10.1.15"
ip_nginx_kibana        = "10.10.1.20"
ip_elk                 = "10.20.2.20"


#logs
log_retention_in_days = "5"
