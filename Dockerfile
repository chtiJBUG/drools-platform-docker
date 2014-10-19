FROM ubuntu:14.04
MAINTAINER Liudmyla Lytvynova

ENV REFRESHED_AT 2014-07-24
RUN apt-get update
RUN apt-get -y upgrade

# avoid debconf and initrd
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

#install
RUN apt-get install -y wget openssh-server supervisor openjdk-7-jdk postgresql-9.3
#openssh-server supervisor openjdk-7-jdk tomcat7 postgresql-9.3 
#RUN mkdir -p /var/run/sshd /var/log/supervisor

# set root password
#RUN echo 'root:root' |chpasswd

#to allow ssh connection, otherwise you'll have 'permission denied" (for Ubuntu 14.04)
#RUN sed --in-place=.bak 's/without-password/yes/' /etc/ssh/sshd_config  

#setup tomcat7
ADD guvnordump /home/guvnor
ADD myconfig /home/guvnor/myconfig
ENV CATALINA_HOME /home/tomcat7/apache-tomcat-7.0
ENV CATALINA_BASE /home/tomcat7/apache-tomcat-7.0
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH /home/tomcat7/apache-tomcat-7.0/bin/catalina.sh
ENV CATALINA_TMPDIR /tmp/tomcat7-tomcat7-tmpRUN
RUN mkdir -p $CATALINA_TMPDIR

# setup postgresql
#ADD set-psql-password.sh /tmp/set-psql-password.sh

#RUN sed -i "/^#listen_addresses/i listen_addresses='*'" /etc/postgresql/9.3/main/postgresql.conf
#RUN sed -i "/^# DO NOT DISABLE\!/i # Allow access from any IP address" /etc/postgresql/9.3/main/pg_hba.conf
#RUN sed -i "/^# DO NOT DISABLE\!/i host all all 0.0.0.0/0 md5\n\n\n" /etc/postgresql/9.3/main/pg_hba.conf

# to install puppet
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
RUN dpkg -i puppetlabs-release-trusty.deb
RUN apt-get update && apt-get install -y puppet

# to copy Puppet code into container
ADD drools_platform_puppet /drools_platform_puppet 
RUN puppet module install puppetlabs/postgresql
#to run Puppet code
RUN puppet apply -d drools_platform_puppet/manifests/site.pp --confdir=drools_platform_puppet/  --modulepath=/etc/puppet/modules:drools_platform_puppet/modules: --libdir=drools_platform_puppet/modules/lib --verbose

# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
#VOLUME [ "/var/lib/tomcat7/webapps/" ]

##ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

USER postgres

# Creates DB and user
#RUN  /etc/init.d/postgresql start && psql -f /tmp/create_guvnor_user.sql && gunzip -c guvnor.gz |  psql guvnor && psql -f /tmp/create_platform_user.sql && psql -f /tmp/create_guvnor_security.sql  && psql --dbname=security -f /tmp/init_guvnor_security.sql 


USER root

# clean packages
RUN apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# tomcat7
EXPOSE 8080

# Expose the PostgreSQL and SSH port
EXPOSE 22
EXPOSE 5432

##RUN /bin/sh /tmp/set-psql-password.sh

CMD ["/usr/bin/supervisord"]

