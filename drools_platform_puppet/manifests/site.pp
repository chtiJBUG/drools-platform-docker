case $operatingsystem { # Install only on Ubuntu 14.04 &
  'ubuntu' : {
    if (!($operatingsystemrelease == '14.04')) {
      fail('Unsupported operating system')
    }
  }
  default  : {
    fail('Unsupported operating system')
  }
}

node default {
  stage { 'dbcontent': require => Stage['main'], }

  stage { 'javaapp': require => Stage['dbcontent'], }

  user { "pymma":
    ensure   => present,
    password => "abcde",
    groups   => ['bin', 'adm', 'root'],
  }

  # include classes from modules


  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    postgres_password          => 'postgres',
  }

  postgresql::server::tablespace { 'guvnor': location => '/var/lib/postgresql/9.3/guvnor' }

  postgresql::server::tablespace { 'platform': location => '/var/lib/postgresql/9.3/platform' }

  postgresql::server::tablespace { 'security': location => '/var/lib/postgresql/9.3/security' }

  postgresql::server::tablespace { 'loyaltyweb': location => '/var/lib/postgresql/9.3/loyaltyweb' }

  postgresql::server::db { 'guvnor':
    user       => 'guvnor',
    password   => 'guvnor',
    tablespace => "guvnor"
  }

  postgresql::server::db { 'platform':
    user       => 'platform',
    password   => 'platform',
    tablespace => "platform"
  }

  postgresql::server::db { 'security':
    user       => 'security',
    password   => 'security',
    tablespace => "security"
  }

  postgresql::server::db { 'loyaltyweb':
    user       => 'loyaltyweb',
    password   => 'loyaltyweb',
    tablespace => "loyaltyweb"
  }

  class { 'pgsqldpf::install':
    stage => dbcontent,
  }

  class { 'java::install':
    stage => javaapp,
  }

  class { 'tomcat7::install':
    stage => javaapp,
  }
  include 'pgsqldpf::install' # include in the installation code of this node the module postgres::install
  include 'java::install' # include in the installation code of this node the module java::install

  include 'tomcat7::install' # include in the installation code of this node the module tomcat::install
}