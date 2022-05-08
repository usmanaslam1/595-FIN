#Golbal
variable "region" {}

#VPC
variable "public_vpc_cidr" {}
variable "public_vpc_name" {}
variable "public_vpc_igw_name" {}


#Public Subnet
variable "public_vpc_pub_subnet_cidr" {}
variable "public_vpc_pub_subnet_name" {}
variable "public_vpc_pub_subnet_rt_name" {}

variable "public_vpc_nat_gw_name" {}
variable "public_vpc_natgw_eip_name" {}


#Private Subnet
variable "public_vpc_priv_subnet_cidr" {}
variable "public_vpc_priv_subnet_name" {}
variable "public_vpc_priv_subnet_rt_name" {}


variable "author" {}
variable "team" {}
