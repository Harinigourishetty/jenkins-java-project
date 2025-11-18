FROM tomcat:9-jdk11

# Install curl
RUN apt-get update && apt-get install -y curl

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Add Nexus credentials (line1=username, line2=password)
ADD nexus-credentials.txt /tmp/nexus.txt

# Download WAR from Nexus
RUN NEXUS_USER=$(sed -n '1p' /tmp/nexus.txt) && \
    NEXUS_PASS=$(sed -n '2p' /tmp/nexus.txt) && \
    curl -u $NEXUS_USER:$NEXUS_PASS \
    -o /usr/local/tomcat/webapps/mywebapp.war \
    "http://3.19.188.209:8081/repository/maven-releases/in/RAHAM/NETFLIX/1.2.2/NETFLIX-1.2.2.war"

EXPOSE 8080
CMD ["catalina.sh", "run"]
