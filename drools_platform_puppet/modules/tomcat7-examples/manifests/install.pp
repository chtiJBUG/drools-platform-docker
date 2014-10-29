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
    
 

    # download loyalty_soap.war :
  lib::wget { "${loyalty_soap}":
    destination => '/home/tomcat7/apache-tomcat-7.0/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${loyalty_soap_source}"),
    require     => [exec["unzip tomcat"], lib::wget["${login}"], file["/home/tomcat7/apache-tomcat-7.0/bin/setenv.sh"]],
  }
   # download loyalty_web.war :
  lib::wget { "${loyalty_web}":
    destination => '/home/tomcat7/apache-tomcat-7.0/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${loyalty_web_source}"),
    require     => [exec["unzip tomcat"], lib::wget["${login}"], file["/home/tomcat7/apache-tomcat-7.0/bin/setenv.sh"]],
  }
   # download swimming_pool.war :
  lib::wget { "${swimming_pool}":
    destination => '/home/tomcat7/apache-tomcat-7.0/webapps/',
    user        => 'tomcat7',
    src         => maven_to_link("${swimming_pool_source}"),
    require     => [exec["unzip tomcat"], lib::wget["${login}"], file["/home/tomcat7/apache-tomcat-7.0/bin/setenv.sh"]],
  }
  
  

}

