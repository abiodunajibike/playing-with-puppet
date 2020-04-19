#!/bin/bash

# Create puppet user on master and add to sudo group
sudo adduser puppet
sudo usermod -aG sudo puppet

# Switch to new user
su - puppet

# Add hosts ip address to /etc/hosts
host_ip_address=$(ifconfig ens5 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
echo "Host IP address: $host_ip_address"
echo "$host_ip_address puppet" | sudo tee -a /etc/hosts

# Enable the official Puppet Labs collection repository with these commands
curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
sudo apt-get update -y

# Install the puppetserver package
sudo apt-get install puppetserver -y

# Configure memory allocation
## By default, Puppet Server is configured to use 2 GB of RAM. 
## You can customize this setting based on how much free memory 
## the master server has and how many agent nodes it will manage.
sed -i 's/JAVA_ARGS*/JAVA_ARGS="-Xms512m -Xmx512m -XX:MaxPermSize=256m"' /etc/default/puppetserver

# Open the firewall
sudo ufw allow 8140

# Start Puppet server
sudo systemctl start puppetserver

# Configure it to start at boot
sudo systemctl enable puppetserver

# See puppet server status
sudo systemctl status puppetserver