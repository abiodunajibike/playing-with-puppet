#!/bin/bash

echo "------- Copying file ./lamp/manifests/site.pp into current directory ----------"
sudo cp -rv lamp/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests

echo "------- Checking into /etc/puppetlabs/code/environments/production/modules directory ----------"
cd /etc/puppetlabs/code/environments/production/modules

echo "------- Creating directory /apache/files -------"
sudo mkdir -p /apache/files

echo "------- Checking into directory /apache/files -------"
cd /apache/files

echo "------- Creating info.php -------"
sudo rm -rf info.php
sudo touch info.pp

echo "-------  Adding content to info.php ------- "
echo "<?php  phpinfo(); ?>"  | sudo tee -a info.php

echo "-------  Showing content of info.php ------- "
cat info.php
