# install the jdk 7 on the machine
class java::install {
  package { 'openjdk-7-jdk': # install the java 7 jdk on the machine
    ensure => installed, }
}