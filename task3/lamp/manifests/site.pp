node default {
    class { 'apache':               # use the "apache" module
        default_vhost => false,      #  dont use the default vhost
        default_mods => false,       # dont load default mods
        mpm_module => 'prefork'     # use the "prefork" mpm_module
    }
    include apache::mod::php # include mod php
    apache::vhost { 'example.com':  # create a vhost called "example.com"
        port => '80',
        docroot => '/var/www/html', # set the docroot to the /var/www/html
    }

    class { 'mysql::server':
        root_password => 'password',
    }

    file {'info.php':                                   # file resource name
        path => '/var/www/html/info.php',               # destination path
        ensure => file,
        require => Class['apache'],                     # require apache class be used
        source => 'puppet:///modules/apache/info.php'   # specify location of file to be copied
                                                        # this gets interpreted into 
                                                        # /etc/puppet/modules/apache/files/info.php
                                                        # so we must create the source file in order
                                                        # for this resource declaration to work properly.
    }
}