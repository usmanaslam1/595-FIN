packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "jump" {
  ami_name      = "Jump Box - ${uuidv4()}"
  instance_type = "${var.instance_type}"
  region        =  "${var.region}"
  source_ami    =  "${var.base_ami}"
  ssh_username = "${var.ssh_user}"
  tags={
    Name="Jump Server"
    created="${timestamp()}"
  }
}

build {
  name = "jump"
  sources = [
    "source.amazon-ebs.jump"
  ]
  provisioner "file" {
    source      = ".files/${var.keyfile_name}"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = ".files/remote.sh"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = ".files/bashrc"
    destination = "/tmp/"
  }

  provisioner "shell" {

  inline = [
      "sudo yum update -y",
      "sudo mv  /tmp/${var.keyfile_name} /root/.ssh",
      "sudo mv -f /tmp/bashrc /root/.bashrc",
      "sudo chown root:root /root/.ssh/${var.keyfile_name}",
      "sudo chmod  400 /root/.ssh/${var.keyfile_name}",
      "sudo mkdir /root/scripts",
      "sudo mv /tmp/remote.sh /root/scripts",
      "sudo chown root:root  /root/scripts/remote.sh",
      "sudo chmod u+x /root/scripts/remote.sh"
    ]
  }
}


#  source_ami_filter {
#    filters = {
#      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
#      root-device-type    = "ebs"
#      virtualization-type = "hvm"
#    }
#  }
