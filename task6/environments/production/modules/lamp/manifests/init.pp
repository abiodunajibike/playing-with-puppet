## Note: the name of this module, lamp, macthes the directory name
class lamp {
    $doc_root = "/var/www/example"

    ### ------------------ Apache ------------------ ###
    # execute 'apt-get update'
    exec { 'apt-update':                        # exec resource named 'apt-update'
        command => '/usr/bin/apt-get update'    # command this resource will run
    }

    # install apache2 package
    package { 'apache2':
        require => Exec['apt-update'], # require apt-update before installing
        ensure => installed,
    }

    #set vhost template
    file { "/etc/apache2/sites-available/000-default.conf":
        ensure => "present",
        content => template("lamp/vhost.erb"),
        notify => Service['apache2'],
        require => Package['apache2']
    }

    # ensure apache2 service is running
    service { 'apache2':
        ensure => running,
        enable => true
    }

    #create doc root directory
    file { $doc_root:
        ensure => "directory",
        owner => "www-data",
        group => "www-data",
        mode => "644"
    }

    #copy index html file
    file { "$doc_root/index.html":
        ensure => "present",
        source => "puppet:///modules/lamp/index.html",
        require => File[$doc_root]
    }
    ### ------------------ Apache -------------------- ###

    ### ------------------ MySQL ------------------ ###
    # install mysql-server package
    package { 'mysql-server':
        require => Exec['apt-update'], # require apt-update before installing
        ensure => installed,
    }

    # ensure mysql service is running
    service { 'mysql':
        ensure => running,
        enable => true
    }
    ### ------------------ MySQL ------------------ ###
}
