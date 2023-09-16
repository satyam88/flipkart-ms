FROM tomcat:9.0.52-jre11-openjdk-slim
COPY ./target/flipkart-ms*.jar /usr/local/tomcat/webapps
EXPOSE  8080
USER flipkart
WORKDIR /usr/local/tomcat/webapps
CMD ["catalina.sh", "run"]
