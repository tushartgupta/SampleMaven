FROM tomcat:8.5
LABEL webapp="maven_built"
# Take the war and copy to webapps of tomcat
COPY target/*.war /usr/local/tomcat/webapps/
