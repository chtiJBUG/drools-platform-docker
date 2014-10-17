# Wget method
# default the user who executes the wget is root with a timeout of 10 sec
define lib::wget ($src, $destination, $timeout = 100, $user = 'root') {
  if !defined(Package['wget']) {
    package { 'wget': ensure => installed } # ensure that wget is present on the machine
  }

  # Execute the wget
  exec { "${name}wget":
    cwd     => "$destination", # $destination is the absolute path of the direcotry where the command will be executed
    user    => $user, # $user is the name of the user which exec this command
    command => "/usr/bin/wget --timeout=$timeout $src -O ${name}", # $src$name is the full link of the file to download
    creates => "$destination/$name",
  }
}
