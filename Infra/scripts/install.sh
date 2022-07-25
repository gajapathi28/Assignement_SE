#!/bin/bash
sudo yum update -y
sudo yum install -y python3-pip
# Upgrade pip3.
sudo pip3 install --upgrade pip
# Install Ansible.
pip3 install "ansible==2.9.17"