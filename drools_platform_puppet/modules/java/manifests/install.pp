# install the jdk 7 on the machine
#include 'Puppet::Parser::Functions'
class java::install {
  package { 'openjdk-7-jdk': # install the java 7 jdk on the machine
    ensure => installed, }

  package { "openssh-server": ensure => present }
}

