#!/usr/bin/env bash
set -eu
COPY helloworld.war /opt/tomcat/webapps/
/opt/tomcat/bin/catalina.sh run