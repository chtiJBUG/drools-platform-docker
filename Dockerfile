FROM ubuntu:14.04
MAINTAINER Liudmyla Lytvynova

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install nano

#to install wget
RUN apt-get install -y wget

# to install puppet
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
RUN dpkg -i puppetlabs-release-trusty.deb
RUN apt-get update
RUN apt-get install -y puppet

# to copy Puppet code into container
ADD drools_platform_puppet /drools_platform_puppet

#to run Puppet code
RUN puppet apply drools_platform_puppet/manifests/site.pp --confdir=drools_platform_puppet  --modulepath=drools_platform_puppet/modules --verbose

USER postgres
# Creates DB and users 
        
RUN    /etc/init.d/postgresql start && psql -f /tmp/create_guvnor_user.sql &&  psql -f /tmp/create_platform_user.sql

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]

ENV CATALINA_HOME /usr/share/tomcat7
ENV CATALINA_BASE /var/lib/tomcat7
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH /usr/share/tomcat7/bin/catalina.sh
ENV CATALINA_TMPDIR /tmp/tomcat7-tomcat7-tmpRUN
RUN mkdir -p $CATALINA_TMPDIR

RUN service postgresql start

#VOLUME [ "/var/lib/tomcat7/webapps/" ]
USER root
EXPOSE 8080
ENTRYPOINT [ "/usr/share/tomcat7/bin/catalina.sh", "run" ]