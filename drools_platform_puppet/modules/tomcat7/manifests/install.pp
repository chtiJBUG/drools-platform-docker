# install the tomcat7 on the machine
class tomcat7::install (
  $jdbc,
  $jdbc_source,
  $login_source,
  $login,
  $designer,
  $drools_guvnor,
  $guvnor_source,
  $designer_source,
  $drools_platform,
  $drools_platform_source) {
  package { 'tomcat7': ensure => installed } # install the package tomcat7



  package { 'tomcat7-admin': # install the package tomcat7-admin
    ensure  => installed,
    require => Package['tomcat7']
  }

  service { 'tomcat7': # run the package tomcat7 in at boot
    ensure     => stopped,
    enable     => true,
    hasrestart => true,
    require    => [Package['tomcat7', 'tomcat7-admin'], Package['openjdk-7-jdk']],
  }

  # creates directory /home/guvnor
  file { "/home/$postgresql::install::guvnor":
    ensure  => directory,
    owner   => 'tomcat7',
    mode    => '0664',
    require => [Package["tomcat7"]],
  }

  file { "/home/$postgresql::install::guvnor/repository.xml": # create file from template
    ensure  => present,
    owner   => 'tomcat7',
    mode    => '0664',
    content => template('tomcat7/repository.xml.erb'),
    require => File["/home/$postgresql::install::guvnor"]
  }

  file { "/var/lib/tomcat7/conf/tomcat-users.xml": # create file from template
    ensure  => present,
    replace => true,
    owner   => 'tomcat7',
    mode    => '0664',
    notify  => Service['tomcat7'],
    content => template('tomcat7/tomcat-users.xml.erb'),
    require => [Package['tomcat7', 'tomcat7-admin']],
  }

  file { "/var/lib/tomcat7/conf/jaasConfig":
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/tomcat7/jaasConfig',
    owner   => tomcat7,
    mode    => 664,
    require => Package['tomcat7']
  }

  file { "/var/lib/tomcat7/conf/server.xml":
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/tomcat7/server.xml',
    owner   => tomcat7,
    mode    => 664,
    require => Package['tomcat7']
  }

  file { "/var/lib/tomcat7/conf/context.xml":
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/tomcat7/context.xml',
    owner   => tomcat7,
    mode    => 664,
    require => Package['tomcat7']
  }

  file { "/usr/share/tomcat7/bin/setenv.sh":
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/tomcat7/setenv.sh',
    owner   => tomcat7,
    mode    => 774,
    require => Package['tomcat7']
  }

  # download drools-guvnor.war :
  lib::wget { "${drools_guvnor}":
    destination => '/var/lib/tomcat7/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${guvnor_source}"),
    require     => [Package['tomcat7']],
    notify      => Service['tomcat7'],
  }

  # download designer.war :
  lib::wget { "${designer}":
    destination => '/var/lib/tomcat7/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${designer_source}"),
    require     => [Package['tomcat7']],
    notify      => Service['tomcat7'],
  }

  # download drools-platform-login.jar :
  lib::wget { "${login}":
    destination => '/usr/share/tomcat7/lib/',
    user        => 'root',
    src         => maven_to_link("${login_source}"),
    require     => [Package['tomcat7']],
    notify      => Service['tomcat7'],
  }
  # download drools-platform-login.jar :
  lib::wget { "${jdbc}":
    destination => '/usr/share/tomcat7/lib/',
    user        => 'root',
    src         => "$jdbc_source",
    require     => [Package['tomcat7']],
    notify      => Service['tomcat7'],
  }

  # download drools-platform-ui.war :
  lib::wget { "${drools_platform}":
    destination => '/var/lib/tomcat7/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${drools_platform_source}"),
    require     => [Package['tomcat7', 'tomcat7-admin']],
    notify      => Service['tomcat7'],
  }

}

