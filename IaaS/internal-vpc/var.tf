#Golbal
variable "region" {}

#VPC
variable "private_vpc_cidr" {}
variable "private_vpc_name" {}
variable "private_vpc_igw_name" {}


#Public Subnet
variable "private_vpc_pub_subnet_cidr" {}
variable "private_vpc_pub_subnet_name" {}
variable "private_vpc_pub_subnet_rt_name" {}

variable "private_vpc_nat_gw_name" {}
variable "private_vpc_natgw_eip_name" {}


#Private Subnet
variable "private_vpc_priv_subnet_cidr" {}
variable "private_vpc_priv_subnet_name" {}
variable "private_vpc_priv_subnet_rt_name" {}


variable "author" {}
variable "team" {}
