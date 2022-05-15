resource "aws_network_interface" "wordpress-nic-1" {
  subnet_id       = aws_subnet.pub_subnet.id
  private_ips     = [var.ip_wordpress_instance1]
  security_groups = [aws_security_group.ssh-from-jumpbox-pub.id, aws_security_group.web-access-from-anywhere.id]

  tags = {
    Name   = "WordPress Web Server - Primary Network Interface"
    Author = var.author
    Team   = var.team
  }
}

resource "aws_eip" "wordpress_box_eip" {
  vpc = true
  tags = {
    Name   = "Elastic IP to use with Wordpress"
    Author = var.author
    Team   = var.team
  }
}

resource "aws_eip_association" "wordpress_box_eip_assoc" {
  instance_id   = aws_instance.wordpress_instance_1.id
  allocation_id = aws_eip.wordpress_box_eip.id
}

resource "aws_instance" "wordpress_instance_1" {
  ami           = var.wordpress_ami
  instance_type = var.wordpress_instance_type
  key_name      = var.keypair_name
  network_interface {
    network_interface_id = aws_network_interface.wordpress-nic-1.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name              = "595 - WordPress Instance 1"
    Author            = var.author
    Team              = var.team
    cloud-watch-agent = true
  }

}
