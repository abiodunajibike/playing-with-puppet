#!/bin/bash

proj_directory=$HOME/playing-with-puppet

echo "------------- Configuring puppet master ------------------------"
$proj_directory/scripts/configure_master.sh

echo "------------- Installing puppet modules ------------------------"
$proj_directory/task3/install_puppet_modules.sh

echo "------- Copying file ./lamp/manifests/site.pp into current directory ----------"
sudo cp -rv $proj_directory/task3/lamp/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests

echo "------- Checking into /etc/puppetlabs/code/environments/production/modules directory ----------"
cd /etc/puppetlabs/code/environments/production/modules/apache/files

# echo "------- Creating directory /apache/files -------"
# sudo mkdir -p /apache/files

# echo "------- Checking into directory /apache/files -------"
# cd /apache/files

echo "------- Creating info.php -------"
sudo rm -rf info.php
sudo touch info.pp

echo "-------  Adding content to info.php ------- "
echo "<?php  phpinfo(); ?>"  | sudo tee -a info.php

echo "-------  Showing content of info.php ------- "
cat info.php
