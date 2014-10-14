#!/bin/sh
JAVA_OPTS="$JAVA_OPTS -Ddrools.platform.conf=/home/guvnor/myconfig"
export JAVA_OPTS   
CATALINA_OPTS="-Xms1536m -Xmx6536m -XX:NewSize=256m -XX:MaxNewSize=256m -XX:PermSize=256m -XX:MaxPermSize=556m -XX:+DisableExplicitGC -Djava.security.auth.login.config=/home/nheron/workspace-ivy-showroom/apache-tomcat-7.0.53/conf/jaasConfig"