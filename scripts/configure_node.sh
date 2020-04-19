#!/bin/bash

# # Create puppet user on master and add to sudo group
# sudo adduser node1
# sudo usermod -aG sudo puppet

# # Switch to new user
# su - node1

# Add master ip address to /etc/hosts
echo "------------- Adding master private IP address to /etc/hosts ------------------------"
master_ip_address=$1
if  [ $# -eq 0 ]
    then
        echo "No Master IP address specified"
        exit 1
fi
echo "Master IP address: $master_ip_address"
echo "$master_ip_address puppet" | sudo tee -a /etc/hosts

# Enable the official Puppet Labs collection repository with these commands
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
sudo apt-get update -y

# Install the puppet agent package
sudo apt-get install puppet-agent -y

# Start Puppet server
sudo systemctl start puppet

# Configure it to start at boot
sudo systemctl enable puppet

# See puppet agent status
sudo systemctl status puppet