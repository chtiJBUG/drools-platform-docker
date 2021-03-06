# install the tomcat7 on the machine
class tomcat7::install (
  $jdbc,
  $jdbc_source,
  $login_source,
  $dbutils_source,
  $dbutils,
  $login,
  $designer,
  $drools_guvnor,
  $guvnor_source,
  $designer_source,
  $drools_platform,
  $drools_platform_source,
  $loyalty_soap,
  $loyalty_soap_source,
  $loyalty_web,
  $loyalty_web_source,
  $swimming_pool,
  $swimming_pool_source) {
  user { "tomcat7":
    ensure     => "present",
    managehome => true,
  }

  lib::wget { "apache-tomcat-7.0.62.tar.gz":
    destination => '/home/tomcat7',
    user        => 'tomcat7',
    src         => "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.62/bin/apache-tomcat-7.0.62.tar.gz",
    require     => [Package['openjdk-7-jdk'], user["tomcat7"]],
  }

  exec { "unzip tomcat":
    command => "tar xvfz  /home/tomcat7/apache-tomcat-7.0.62.tar.gz -C /home/tomcat7 && mv /home/tomcat7/apache-tomcat-7.0.62 /home/tomcat7/apache-tomcat-7.0 ",
    path    => "/usr/local/bin/:/bin/:/usr/sbin/:/usr/bin",
    require => [lib::wget["apache-tomcat-7.0.62.tar.gz"]],
    user    => "tomcat7"
  }

  file { "/home/tomcat7/apache-tomcat-7.0/bin/catalina.sh":
    mode    => 755,
    require => [exec["unzip tomcat"]],
  }

# creates directory /home/guvnor
  file { "/data":
    ensure  => directory,
    owner   => 'tomcat7',
    mode    => '0664',
    require => [exec["unzip tomcat"]],
  }
  file { "/data/dumps":
    ensure  => directory,
    owner   => 'tomcat7',
    mode    => '0664',
    require => File["/data"],
  }
  # creates directory /home/guvnor
  file { "/home/guvnor":
    ensure  => directory,
    owner   => 'tomcat7',
    mode    => '0664',
    require => [exec["unzip tomcat"]],
  }

  file { "/home/guvnor/repository.xml": # create file from template
    ensure  => present,
    owner   => 'tomcat7',
    mode    => '0664',
    content => template('tomcat7/repository.xml.erb'),
    require => File["/home/guvnor"]
  }
 
  exec { "unzip guvnorzip":
    command => "tar xvfz  /home/guvnor/guvnor-index.tar.gz -C /home/guvnor",
    path    => "/usr/local/bin/:/bin/:/usr/sbin/:/usr/bin",
    require => File["/home/guvnor"],
    user    => "tomcat7"
  }
  
  

  file { "/home/tomcat7/apache-tomcat-7.0/conf/tomcat-users.xml": # create file from template
    ensure  => present,
    replace => true,
    owner   => 'tomcat7',
    mode    => '0664',
    content => template('tomcat7/tomcat-users.xml.erb'),
    require => [exec["unzip tomcat"]],
  }

  file { "/home/tomcat7/apache-tomcat-7.0/conf/jaasConfig":
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/tomcat7/jaasConfig',
    owner   => tomcat7,
    mode    => 664,
    require => exec["unzip tomcat"]
  }

  file { "/home/tomcat7/apache-tomcat-7.0/conf/server.xml":
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/tomcat7/server.xml',
    owner   => tomcat7,
    mode    => 664,
    require => exec["unzip tomcat"]
  }

  file { "/home/tomcat7/apache-tomcat-7.0/conf/context.xml":
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/tomcat7/context.xml',
    owner   => tomcat7,
    mode    => 664,
    require => [exec["unzip tomcat"], file["/home/tomcat7/apache-tomcat-7.0/conf/server.xml"]]
  }

  file { "/home/tomcat7/apache-tomcat-7.0/bin/setenv.sh":
    ensure  => present,
    replace => true,
    source  => 'puppet:///modules/tomcat7/setenv.sh',
    owner   => tomcat7,
    mode    => 774,
    require => [exec["unzip tomcat"], file["/home/tomcat7/apache-tomcat-7.0/conf/server.xml"]]
  }

  # download drools-guvnor.war :
  lib::wget { "${drools_guvnor}":
    destination => '/home/tomcat7/apache-tomcat-7.0/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${guvnor_source}"),
    require     => [
      exec["unzip tomcat"],
      lib::wget["${login}"],
      file["/home/tomcat7/apache-tomcat-7.0/bin/setenv.sh"],
      file["/home/guvnor"]],
  }

  # download designer.war :
  lib::wget { "${designer}":
    destination => '/home/tomcat7/apache-tomcat-7.0/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${designer_source}"),
    require     => [exec["unzip tomcat"]],
  }

  # download drools-platform-login.jar :
  lib::wget { "${login}":
    destination => '/home/tomcat7/apache-tomcat-7.0/lib/',
    user        => 'root',
    src         => maven_to_link("${login_source}"),
    require     => [
      exec["unzip tomcat"],
      lib::wget["${dbutils}"],
      lib::wget["${jdbc}"],
      file["/home/tomcat7/apache-tomcat-7.0/bin/setenv.sh"]],
  }

  # download pgsql-jdbc.jar :
  lib::wget { "${jdbc}":
    destination => '/home/tomcat7/apache-tomcat-7.0/lib/',
    user        => 'root',
    src         => "$jdbc_source",
    require     => [exec["unzip tomcat"]],
  }

  # download DBUtils.war :
  lib::wget { "${dbutils}":
    destination => '/home/tomcat7/apache-tomcat-7.0/lib',
    user        => 'root',
    src         => "$dbutils_source",
    require     => [exec["unzip tomcat"]],
  }

  # download drools-platform-ui.war :
  lib::wget { "${drools_platform}":
    destination => '/home/tomcat7/apache-tomcat-7.0/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${drools_platform_source}"),
    require     => [exec["unzip tomcat"], lib::wget["${login}"], file["/home/tomcat7/apache-tomcat-7.0/bin/setenv.sh"]],
  }
 
  

}

