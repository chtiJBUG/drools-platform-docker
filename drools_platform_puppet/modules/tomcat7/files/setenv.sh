#!/bin/sh
JAVA_OPTS="$JAVA_OPTS -Ddrools.platform.conf=/home/guvnor/myconfig"
export JAVA_OPTS   
until /usr/bin/pg_isready
do
sleep 1
echo "not ready"
done
CATALINA_OPTS="-Xms1536m -Xmx12536m -XX:NewSize=256m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/data/dumps -XX:MaxNewSize=256m -XX:PermSize=256m -XX:MaxPermSize=556m -XX:+DisableExplicitGC -Djava.security.auth.login.config=/home/tomcat7/apache-tomcat-7.0/conf/jaasConfig"