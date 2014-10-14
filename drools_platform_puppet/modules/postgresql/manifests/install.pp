class postgresql::install (
  $tablespacedir,
  $platform,
  $guvnor,
  $guvnor_psswd,
  $platform_psswd,
  $security_db,
  $security_password,
  $security_user) {
    
  $ipnetwork = '127.0.0.1/32'
  $portpsql = '3306'

  package { 'postgresql-9.3': ensure => installed } # install the package postgresql-9.3s



  service { 'postgresql': # runs postgresql at boot
    ensure     => stopped,
    enable     => true,
    hasrestart => true,
    require    => [Package['postgresql-9.3']],
  }

  file { "${tablespacedir}": # create the directory /var/lib/postgresql/9.1/main/myspace
    ensure  => directory,
    owner   => 'postgres', # the owner of the directory will be postgres
    require => [Package['postgresql-9.3']],
  }

  file { ["${tablespacedir}/$guvnor", "${tablespacedir}/$platform"]: # create the directory
                                                                     # /var/lib/postgresql/9.3/main/myspace/guvnor
    ensure  => directory,
    owner   => 'postgres', # the owner of the directory will be postgres
    require => [File["${tablespacedir}"]],
  }

  file { ["/tmp/create_guvnor_user.sql"]: # create script sql from template
    ensure  => present,
    content => template("postgresql/create_guvnor_user.sql.erb"),
    owner   => 'postgres',
    require => [Package['postgresql-9.3']],
  }

  file { ["/tmp/create_platform_user.sql"]: # create script sql from template
    ensure  => present,
    content => template("postgresql/create_platform_user.sql.erb"),
    owner   => 'postgres',
    require => [Package['postgresql-9.3']],
  }
  file { ["/tmp/create_guvnor_security.sql"]: # create script sql from template
    ensure  => present,
    content => template("postgresql/create_guvnor_security.sql.erb"),
    owner   => 'postgres',
    require => [Package['postgresql-9.3']],
  }
}
