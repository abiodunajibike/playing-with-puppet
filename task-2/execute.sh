#!/bin/bash

echo "------- Checking into /etc/puppetlabs/code/environments/production/modules directory ----------"
cd /etc/puppetlabs/code/environments/production/modules

echo "------- Creating directory lamp/manifests ----------"
sudo mkdir -p lamp/manifests

echo "------- Copying file ./lamp/manifests/init.pp into current directory ----------"
sudo cp -rv ./lamp/manifests/init.pp /etc/puppetlabs/code/environments/production/modules/lamp/manifests

echo "------- Checking into /etc/puppetlabs/code/environments/production/manifests directory ----------"
cd /etc/puppetlabs/code/environments/production/manifests

echo "------- Creating site.pp -------"
sudo rm -rf site.pp
sudo touch site.pp

echo "-------  Adding content to site.pp ------- "
echo "node default { include lamp }" | sudo tee -a site.pp

echo "-------  Showing content of site.pp ------- "
cat site.pp