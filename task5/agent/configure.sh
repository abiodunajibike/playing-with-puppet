#!/bin/bash

## To apply manifest on puppet node:
## sudo /opt/puppetlabs/bin/puppet agent --test

## To see puppet.conf
## cat /etc/puppetlabs/puppet/puppet.conf

## To use a custom puppet config
## sudo /opt/puppetlabs/bin/puppet agent -t --config ./agent_puppet.conf

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
        echo "No Master private IP address specified"
        exit 1
fi
echo "Master private IP address: $master_ip_address"
echo "$master_ip_address puppet" | sudo tee -a /etc/hosts

# Enable the official Puppet Labs collection repository with these commands
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
sudo apt-get update -y

# # Install puppet-agent, puppet-common packages
# sudo apt-get install -y puppet-common puppet-agent

# Install puppet-agent, puppet-common packages
sudo apt-get install -y puppet-agent

# Copy puppet.conf to /etc/puppetlabs/puppet/puppet.conf
echo "HOME directory is: $HOME"

echo "------------- Copying puppet.conf to /etc/puppetlabs/puppet/puppet.conf ------------------------"
sudo cp -rv $HOME/playing-with-puppet/task5/agent/puppet.conf \
    /etc/puppetlabs/puppet/puppet.conf

# Start Puppet server
sudo systemctl start puppet

# Configure it to start at boot
sudo systemctl enable puppet

# See puppet agent status
sudo systemctl status puppet