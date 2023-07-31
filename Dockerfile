FROM tomcat:8.0
ADD ./target/*.war /usr/local/tomcat/webapps/
EXPOSE 8181
WORKDIR /usr/local/tomcat/webapps/
CMD ["catalina.sh","run"]

