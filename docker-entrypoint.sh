#!/bin/bash

set -e

# import trusted ssl certs into JRE keystore
import-trusted-ssl-certs.sh

# exec command if available
if [ -n "$@" ] ; then exec "$@" ; fi

# start nexus application
exec java \
     -cp "./conf/:./lib/*" \
     -Dnexus-work=$SONATYPE_WORK \
     -Dnexus-webapp-context-path=$NEXUS_CONTEXT_PATH \
     $NEXUS_JAVA_OPTS \
     org.sonatype.nexus.bootstrap.Launcher "./conf/jetty.xml" "./conf/jetty-requestlog.xml"
