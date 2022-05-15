#Golbal
variable "region" {}

#VPC
variable "public_vpc_cidr" {}
variable "public_vpc_name" {}
variable "public_vpc_igw_name" {}
variable "private_vpc_igw_name" {}

#Public Subnet
variable "public_vpc_pub_subnet_cidr" {}
variable "public_vpc_pub_subnet_2_cidr" {}
variable "public_vpc_pub_subnet_name" {}
variable "public_vpc_pub_subnet_2_name" {}
variable "public_vpc_pub_subnet_rt_name" {}
variable "public_vpc_pub_subnet_rt_2_name" {}

variable "public_vpc_nat_gw_name" {}
variable "public_vpc_natgw_eip_name" {}


#Private Subnet
variable "public_vpc_priv_subnet_cidr" {}
variable "public_vpc_priv_subnet_name" {}
variable "public_vpc_priv_subnet_rt_name" {}


variable "author" {}
variable "team" {}
#Golbal

#VPC
variable "private_vpc_cidr" {}
variable "private_vpc_name" {}

#Private Subnet
variable "private_vpc_priv_subnet_cidr" {}
variable "private_vpc_priv_subnet_name" {}
variable "private_vpc_priv_subnet_rt_name" {}


variable "jump_box_ami" {}
variable "jump_box_instance_type" {}
variable "keypair_name" {}
variable "keyfile_name" {}
variable "default_route_cidr" {}
variable "private_vpc_pub_subnet_name" {}
variable "private_vpc_pub_subnet_cidr" {}
variable "private_vpc_pub_subnet_rt_name" {}
variable "private_vpc_natgw_eip_name" {}
variable "private_vpc_nat_gw_name" {}
variable "wordpress_instance_type" {}

#IP addresses
variable "ip_jump_box" {}
variable "ip_wordpress_instance1" {}
variable "ip_elk" {}
variable "elk_box_ami" {}
variable "wordpress_ami" {}
variable "elk_box_instance_type" {}
variable "nginx_kibana_instance_type" {}
variable "nginx_kibana_ami" {}
variable "ip_nginx_kibana" {}


#logs

variable "log_retention_in_days" {}
