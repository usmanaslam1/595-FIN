resource "aws_security_group" "ssh-from-anywhere" {
  name        = "VPC1:SSH Access from Anywhere"
  description = "SSH access from anywhere"

  vpc_id = aws_vpc.PublicVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "VPC1:SSH Access from Anywhere"
    Description = "SSH access from internet"
    Author      = var.author
    Team        = var.team
  }
}

resource "aws_security_group" "mysql-access" {
  name        = "VPC1:MySQL Access"
  description = "MySQL (RDS) access for wordpress"

  vpc_id = aws_vpc.PublicVPC.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.ip_wordpress_instance1}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "VPC1:MySQL Access"
    Description = "MySQL access"
    Author      = var.author
    Team        = var.team
  }
}

resource "aws_security_group" "ssh-from-jumpbox-pub" {
  name        = "VPC1:SSH Access From Jumpbox"
  description = "SSH access from Jump Box"
  vpc_id      = aws_vpc.PublicVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip_jump_box}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "VPC2:SSH Access From Jumpbox"
    Description = "SSH access from jumpbox"
    Author      = var.author
    Team        = var.team

  }
}


resource "aws_security_group" "web-access-from-anywhere" {
  name        = "VPC1:HTTP Access From Internet"
  description = "HTTP access to public"
  vpc_id      = aws_vpc.PublicVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "VPC1:HTTP Access From Internet"
    Description = "SSH access from jumpbox"
    Author      = var.author
    Team        = var.team

  }
}



############################PRIVATE VPC######################
resource "aws_security_group" "ssh-from-jumpbox" {
  name        = "VPC2:SSH Access From Jumpbox"
  description = "SSH access from Jump Box"
  vpc_id      = aws_vpc.PrivateVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip_jump_box}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_route_cidr]
  }

  tags = {
    Name        = "VPC2:SSH Access From Jumpbox"
    Description = "SSH access from jumpbox"
    Author      = var.author
    Team        = var.team
  }

}


##ELK
resource "aws_security_group" "elk-from-public" {
  name        = "VPC2:ELK access from public"
  description = "ELK access from public"
  vpc_id      = aws_vpc.PrivateVPC.id

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [var.public_vpc_pub_subnet_cidr]
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = [var.public_vpc_pub_subnet_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_route_cidr]
  }

  tags = {
    Name        = "VPC2: ELK Access"
    Description = "ELK Access from public subnet"
    Author      = var.author
    Team        = var.team

  }
}
