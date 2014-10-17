# install the jdk 7 on the machine
# include 'Puppet::Parser::Functions'
class java::install {
  package { 'openjdk-7-jdk': # install the java 7 jdk on the machine
    ensure => installed, }

  package { "openssh-server": ensure => present }

  package { "supervisor": ensure => present }

 

  file { "/var/log/admin-app-log":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 750
  }

  exec { "mkdir":
    command => "mkdir -p /var/run/sshd /var/log/supervisor",
    path    => "/usr/local/bin/:/bin/"
  }

  exec { "set root password":
    command => "echo 'root:root' |chpasswd",
    path    => "/usr/local/bin/:/bin/:/usr/sbin/"
  }

  exec { "to allow ssh connection, otherwise you will have permission denied (for Ubuntu 14.04)":
    command => "sed --in-place=.bak 's/without-password/yes/' /etc/ssh/sshd_config",
    path    => "/usr/local/bin/:/bin/:/usr/sbin/",
    require => [Package['openssh-server']]
  }

  file { '/etc/supervisor/conf.d/supervisord.conf':
    ensure  => present,
    replace => true,
    content => template('java/supervisord.conf'),
    require => [Package['supervisor']]
  }

}
