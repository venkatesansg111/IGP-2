# Use official Tomcat image
FROM tomcat:9.0-jdk11

# Clean default apps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR to Tomcat webapps directory
COPY target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps/ABCtechnologies.war

# Expose default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]