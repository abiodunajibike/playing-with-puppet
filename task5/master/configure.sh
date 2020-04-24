#!/bin/bash

# # Create puppet user on master and add to sudo group
# sudo adduser puppet
# sudo usermod -aG sudo puppet

# # Switch to new user
# su - puppet

# Add hosts ip address to /etc/hosts
echo "------------- Adding host private IP address to /etc/hosts ------------------------"
host_ip_address=$(ifconfig ens5 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
echo "Host IP address: $host_ip_address"
echo "$host_ip_address puppet" | sudo tee -a /etc/hosts

# Enable the official Puppet Labs collection repository with these commands
echo "------------- Enable the official Puppet Labs collection repository ------------------------"
curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
sudo apt-get update -y

# Install the puppetserver package
echo "------------- Installing puppetserver ------------------------"
sudo apt-get install -y puppetserver

# Configure memory allocation
## By default, Puppet Server is configured to use 2 GB of RAM. 
## You can customize this setting based on how much free memory 
## the master server has and how many agent nodes it will manage.
echo "------------- Updating memory allocation for puppet server ------------------------"
sudo sed -i 's/JAVA_ARGS=.*/JAVA_ARGS="-Xms512m -Xmx512m -XX:MaxPermSize=256m"/' /etc/default/puppetserver

# Copy puppet.conf to /etc/puppetlabs/puppet/puppet.conf
echo "------------- Copying puppet.conf to /etc/puppetlabs/puppet/puppet.conf ------------------------"
sudo cp -rv /home/ubuntu/playing-with-puppet/task5/master/puppet.conf \
    /etc/puppetlabs/puppet/puppet.conf

# Open the firewall
echo "------------- Opening port 8140 ------------------------"
sudo ufw allow 8140

# Start Puppet server
echo "------------- Starting puppet server ------------------------"
sudo systemctl start puppetserver

# Configure it to start at boot
echo "------------- Enable puppet server to boot on start up ------------------------"
sudo systemctl enable puppetserver

# See puppet server status
echo "------------- Get puppet server status ------------------------"
sudo systemctl status puppetserver > output.txt
cat output.txt

echo "------------- List and/or sign pending certificates ------------------------"
while true; do
    # To list all unsigned certificate requests, run the following command on the Puppet master
    if [ -z "$(sudo /opt/puppetlabs/bin/puppet cert list)" ]; then
        echo "No pending certificates"
        echo "---- Waiting for 10 seconds ----"
        sleep 10
    else
        # To sign a single certificate request
        echo "About to sign all pending certificates"
        sudo /opt/puppetlabs/bin/puppet cert sign --all
        break
    fi
done