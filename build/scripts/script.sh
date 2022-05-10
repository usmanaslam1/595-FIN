#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo cp /tmp/test_files/index.* /var/www/html
sudo yum install -y mysql
sudo yum install -y php
sudo systemctl enable httpd
