ubuntu@ip-172-31-47-74:/etc/puppet$ ls
auth.conf      etckeeper-commit-post  fileserver.conf      manifests  puppet.conf
autosign.conf  etckeeper-commit-pre   fileserver.conf.bak  modules
ubuntu@ip-172-31-47-74:/etc/puppet$ cat puppet.conf 
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/run/puppet
factpath=$vardir/lib/facter
prerun_command=/etc/puppet/etckeeper-commit-pre
postrun_command=/etc/puppet/etckeeper-commit-post

[master]
# These are needed when the puppetmaster is run by passenger
# and can safely be removed if webrick is used.
ssl_client_header = SSL_CLIENT_S_DN 
ssl_client_verify_header = SSL_CLIENT_VERIFY
ubuntu@ip-172-31-47-74:/etc/puppet$ cat autosign.conf 
*.internal
ubuntu@ip-172-31-47-74:/etc/puppet$ ls manifests/
nodes.pp  site.pp
ubuntu@ip-172-31-47-74:/etc/puppet$ cat manifests/nodes.pp 
node basenode { 
  include cfn 
}
node /^.*internal$/ inherits basenode {
  case $cfn_roles {
    /wordpress/: { include wordpress }
  }
}
ubuntu@ip-172-31-47-74:/etc/puppet$ cat manifests/site.pp 
import"nodes"
ubuntu@ip-172-31-47-74:/etc/puppet$ ls modules/
cfn  wordpress
ubuntu@ip-172-31-47-74:/etc/puppet$ ls modules/cfn/
lib  manifests
ubuntu@ip-172-31-47-74:/etc/puppet$ ls modules/cfn/manifests/
init.pp
ubuntu@ip-172-31-47-74:/etc/puppet$ cat modules/cfn/manifests/init.pp 
class cfn {}ubuntu@ip-172-31-47-74:/etc/puppet$ ls m
manifests/ modules/   
ubuntu@ip-172-31-47-74:/etc/puppet$ ls modules/
cfn/       wordpress/ 
ubuntu@ip-172-31-47-74:/etc/puppet$ ls modules/wordpress/
manifests/ templates/ 
ubuntu@ip-172-31-47-74:/etc/puppet$ ls modules/wordpress/manifests/init.pp 
modules/wordpress/manifests/init.pp
ubuntu@ip-172-31-47-74:/etc/puppet$ cat modules/wordpress/manifests/init.pp 
class wordpress {
  package { php: ensure => latest }
  package { php-mysql:
        ensure => latest,
        require => Package["php"] }
  package { wordpress:
        ensure => latest,
        require => Package["php-mysql"] }
  file { "/etc/wordpress/wp-config.php":
        content => template('wordpress/wp-config.erb'),
        require => Package["wordpress"]
  }
  service { httpd:
        enable => true,
        ensure => "running",
        require => File["/etc/wordpress/wp-config.php"]
  }
}
ubuntu@ip-172-31-47-74:/etc/puppet$ cat modules/wordpress/templates/wp-config.erb 
<?php
define('DB_NAME', '<%= cfn_database %>');
define('DB_USER', '<%= cfn_user %>');
define('DB_PASSWORD', '<%= cfn_password %>');
define('DB_HOST', '<%= cfn_host %>');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('AUTH_KEY', '<%= chars=((40..126).map{ |c| c.chr });a=[];64.times { a << chars[rand(chars.size)] }; a.join %>');
define('SECURE_AUTH_KEY', '<%= chars=((40..126).map{ |c| c.chr });a=[];64.times { a << chars[rand(chars.size)] }; a.join %>');
define('LOGGED_IN_KEY', '<%= chars=((40..126).map{ |c| c.chr });a=[];64.times { a << chars[rand(chars.size)] }; a.join %>');
define('NONCE_KEY', '<%= chars=((40..126).map{ |c| c.chr });a=[];64.times { a << chars[rand(chars.size)] }; a.join %>');
$table_prefix  = 'wp_';
define('WPLANG', '');
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
ubuntu@ip-172-31-47-74:/etc/puppet$ apt-get install puppetserver
E: Could not open lock file /var/lib/dpkg/lock - open (13: Permission denied)
E: Unable to lock the administration directory (/var/lib/dpkg/), are you root?
ubuntu@ip-172-31-47-74:/etc/puppet$ sudo apt-get install puppetserver
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: Unable to locate package puppetserver
ubuntu@ip-172-31-47-74:/etc/puppet$ Connection to ec2-3-81-1-221.compute-1.amazonaws.com closed by remote host.
Connection to ec2-3-81-1-221.compute-1.amazonaws.com closed.
╭─moruf@Morufs-MacBook-Pro.local ~/Downloads  
╰─➤                                                                         255 ↵
╭─moruf@Morufs-MacBook-Pro.local ~/Downloads  
╰─➤                                                                         130 ↵