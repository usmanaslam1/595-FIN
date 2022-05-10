variable "region" {
  type = string
  default = "us-west-1"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "base_ami" {
  type = string
  default = "ami-02541b8af977f6cdd"
}

variable "ssh_user" {
  type = string
  default = "ec2-user"
}
