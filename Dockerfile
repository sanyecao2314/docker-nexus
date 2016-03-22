FROM chrisipa/java
MAINTAINER Christoph Papke <info@papke.it>

# set environment variables
ENV SONATYPE_WORK /opt/sonatype-work
ENV NEXUS_HOME /opt/nexus
ENV NEXUS_VERSION 2.12.0-01
ENV NEXUS_CHECKSUM 6a2e026a6ad299fbfc0bd62ed05a0a85
ENV NEXUS_CONTEXT_PATH /
ENV NEXUS_JAVA_OPTS "$NEXUS_ADDITIONAL_JAVA_OPTS -server -Xmx768m -Xms256m -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true"

# install additional packages
RUN apt-get update && \
    apt-get install -y createrepo && \
    apt-get clean

# download and extract sonarqube to opt folder
RUN wget http://download.sonatype.com/nexus/oss/nexus-$NEXUS_VERSION-bundle.zip && \
    echo "$NEXUS_CHECKSUM nexus-$NEXUS_VERSION-bundle.zip" | md5sum -c && \
    unzip nexus-$NEXUS_VERSION-bundle.zip -d /opt && \
    ln -s /opt/nexus-$NEXUS_VERSION $NEXUS_HOME && \
    rm -f nexus-$NEXUS_VERSION-bundle.zip

# remove unused folders
RUN rm -rf $NEXUS_HOME/bin

# expose http port
EXPOSE 8081

# specify volumes
VOLUME $SONATYPE_WORK

# set NEXUS_HOME as work dir
WORKDIR $NEXUS_HOME

# copy entry point to docker image root
COPY docker-entrypoint.sh /entrypoint.sh

# specifiy entrypoint
ENTRYPOINT ["/entrypoint.sh"]
