resource "aws_network_interface" "nic-elk" {
  subnet_id       = aws_subnet.main_subnet.id
  private_ips     = [var.ip_elk]
  security_groups = [aws_security_group.ssh-from-jumpbox.id, aws_security_group.elk-from-public.id]

  tags = {
    Name   = "ELK -Primary Network Interface"
    Author = var.author
    Team   = var.team
  }
}


resource "aws_instance" "elk_box" {
  ami           = var.elk_box_ami
  instance_type = var.elk_box_instance_type
  key_name      = var.keypair_name
  network_interface {
    network_interface_id = aws_network_interface.nic-elk.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name              = "595 - Elastic Search / Kibana"
    Author            = var.author
    Team              = var.team
    cloud-watch-agent = true
  }

}
