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

    file {'templates':                                    # file resource name
        path => '/var/www/html/templates',                # destination path
        ensure => directory,                              # directory
        require => Class['apache'],                       # require apache class be used
        source => 'puppet:///modules/apache/templates',   # specify location of file to be copied
        recurse => true                                   # this gets interpreted into
                                                          # /etc/puppet/modules/apache/files/<all_files>
                                                          # so we must create the source files in order
                                                          # for this resource declaration to work properly.
    }
}