#!/bin/bash

# Create puppet user on master and add to sudo group
sudo adduser node1
sudo usermod -aG sudo puppet

# Switch to new user
su - node1

# Enable the official Puppet Labs collection repository with these commands
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
sudo apt-get update

# Install the puppet agent package
sudo apt-get install puppet-agent

# Start Puppet server
sudo systemctl start puppet

# Configure it to start at boot
sudo systemctl enable puppet

# See puppet agent status
sudo systemctl status puppet