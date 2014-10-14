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
  user { "pymma":
    ensure   => present,
    password => "abcde",
    groups    => ['bin','adm','root'], 
  }
 

  # include classes from modules
  include 'java::install' # include in the installation code of this node the module java::install
  include 'postgresql::install' # include in the installation code of this node the module postgres::install
  include 'tomcat7::install' # include in the installation code of this node the module tomcat::install
}