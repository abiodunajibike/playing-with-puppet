#!/bin/bash

proj_directory=$HOME/playing-with-puppet

echo "------------- Configuring puppet master ------------------------"
$proj_directory/scripts/configure_master.sh

echo "------------- Installing puppet modules ------------------------"
$proj_directory/task3/install_puppet_modules.sh

echo "------- Copying file ./lamp/manifests/site.pp into current directory ----------"
sudo cp -rv $proj_directory/task3/lamp/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests

echo "------- Checking into /etc/puppetlabs/code/environments/production/modules directory ----------"
cd /etc/puppetlabs/code/environments/production/modules

echo "------- Creating directory apache/files/templates -------"
sudo mkdir -p apache/files/templates

echo "------- Checking into directory apache/files/templates -------"
cd apache/files/templates

echo "------- Copying $proj_directory/task3/files content -------"
sudo cp -rv $proj_directory/task3/files/* .