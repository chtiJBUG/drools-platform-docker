FROM ubuntu:14.04
MAINTAINER Nicolas Heron

ENV REFRESHED_AT 2014-07-24

# avoid debconf and initrd
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

#install
RUN  sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN apt-get install -y wget ca-certificates
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN apt-get update
RUN apt-get upgrade  -y
#RUN apt-get install -y wget openssh-server supervisor openjdk-7-jdk postgresql-9.4
RUN apt-get install -y wget openssh-server supervisor openjdk-7-jdk
RUN apt-get install -y  postgresql-9.4

#setup tomcat7
ADD guvnordump /home/guvnor
ADD myconfig /home/guvnor/myconfig
ENV CATALINA_HOME /home/tomcat7/apache-tomcat-7.0
ENV CATALINA_BASE /home/tomcat7/apache-tomcat-7.0
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH /home/tomcat7/apache-tomcat-7.0/bin/catalina.sh
ENV CATALINA_TMPDIR /tmp/tomcat7-tomcat7-tmpRUN
RUN mkdir -p $CATALINA_TMPDIR


# to install puppet
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
RUN dpkg -i puppetlabs-release-trusty.deb
RUN apt-get update && apt-get install -y puppet

# to copy Puppet code into container
ADD drools_platform_puppet /drools_platform_puppet 
RUN puppet module install puppetlabs/postgresql

#to run Puppet code
RUN puppet apply -d drools_platform_puppet/manifests/site.pp --confdir=drools_platform_puppet/  --modulepath=/etc/puppet/modules:drools_platform_puppet/modules: --libdir=drools_platform_puppet/modules/lib --verbose
USER root

# clean packages
RUN apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# tomcat7
EXPOSE 8080

# Expose the PostgreSQL and SSH port
EXPOSE 22
EXPOSE 5432
EXPOSE 61616


CMD ["/usr/bin/supervisord"]

