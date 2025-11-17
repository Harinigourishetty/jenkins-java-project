FROM tomcat:9-jdk11

# Install wget
RUN apt-get update && apt-get install -y wget

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Add Nexus credentials (line1=username, line2=password)
ADD nexus-credentials.txt /tmp/nexus.txt

# Pass artifact name, version, and repository dynamically
ARG ARTIFACT_NAME
ARG ARTIFACT_VERSION
ARG REPOSITORY=maven-releases  # default, override for snapshots

# Download WAR from Nexus dynamically, keep original name
RUN NEXUS_USER=$(sed -n '1p' /tmp/nexus.txt) && \
    NEXUS_PASS=$(sed -n '2p' /tmp/nexus.txt) && \
    wget --user=$NEXUS_USER --password=$NEXUS_PASS \
         -O /usr/local/tomcat/webapps/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.war \
         "http://3.19.188.209:8081/repository/${REPOSITORY}/in/RAHAM/${ARTIFACT_NAME}/${ARTIFACT_VERSION}/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.war"

EXPOSE 8080
CMD ["catalina.sh", "run"]
