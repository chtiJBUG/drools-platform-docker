case $operatingsystem { # Install only on Ubuntu 14.04 &
  'ubuntu' : {
    if (!($operatingsystemrelease =='14.04')) {
      fail('Unsupported operating system')
    }
  }
  default : {
    fail('Unsupported operating system')
  }
}

node default {
  
  # variables hiera
  #$hostname = hiera('hostname')
  

  #exec { "/bin/echo 127.0.0.1 $hostname >> /etc/hosts": }

  # include classes from modules
  include 'java::install' # include in the installation code of this node the module java::install
  include 'postgresql::install' # include in the installation code of this node the module postgres::install
  include 'tomcat7::install' # include in the installation code of this node the module tomcat::install
}