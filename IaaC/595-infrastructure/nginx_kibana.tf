resource "aws_network_interface" "nginx_kibana_nic" {
  subnet_id       = aws_subnet.pub_subnet.id
  private_ips     = [var.ip_nginx_kibana]
  security_groups = [aws_security_group.ssh-from-jumpbox-pub.id, aws_security_group.web-access-from-anywhere.id]

  tags = {
    Name   = "Nginx Kibana -Primary Network Interface"
    Author = var.author
    Team   = var.team
  }
}


resource "aws_eip" "nginx_kibana_eip" {
  vpc = true
  tags = {
    Name   = "Elastic IP to use with Kibana Nginx Web Server"
    Author = var.author
    Team   = var.team
  }
}

resource "aws_eip_association" "nginx_eip_assoc" {
  instance_id   = aws_instance.nginx_kibana.id
  allocation_id = aws_eip.nginx_kibana_eip.id
}

resource "aws_instance" "nginx_kibana" {
  ami           = var.nginx_kibana_ami
  instance_type = var.nginx_kibana_instance_type
  key_name      = var.keypair_name
  network_interface {
    network_interface_id = aws_network_interface.nginx_kibana_nic.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name              = "595 - Kibana Nginx Server"
    Author            = var.author
    Team              = var.team
    cloud-watch-agent = true
  }
}
