#!/bin/bash

## configure master first

echo "------------- Installing puppet with gem ------------------------"
sudo gem install puppet

echo "------------- Installing puppet modules [apache, mysql] ------------------------"
sudo puppet module install puppetlabs-apache
sudo puppet module install puppetlabs-mysql
