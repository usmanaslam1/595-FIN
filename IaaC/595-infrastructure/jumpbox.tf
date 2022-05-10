resource "aws_network_interface" "jumpbox-nic-1" {
  subnet_id       = aws_subnet.pub_subnet.id
  private_ips     = ["10.10.1.10"]
  security_groups = [aws_security_group.ssh-from-anywhere.id]

  tags = {
    Name   = "Primary Network Interface"
    Author = var.author
    Team   = var.team
  }
}

resource "aws_eip" "jump_box_eip" {
  vpc = true
  tags = {
    Name   = "Elastic IP to use with Jump Box"
    Author = var.author
    Team   = var.team
  }
}

resource "aws_eip_association" "jump_box_eip_assoc" {
  instance_id   = aws_instance.jump_box.id
  allocation_id = aws_eip.jump_box_eip.id
}

resource "aws_instance" "jump_box" {
  ami           = var.jump_box_ami
  instance_type = var.jump_box_instance_type
  key_name      = var.keypair_name
  network_interface {
    network_interface_id = aws_network_interface.jumpbox-nic-1.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name   = "595 - Jump Box"
    Author = var.author
    Team   = var.team
  }

}
