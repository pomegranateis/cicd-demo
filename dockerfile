FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/*.jar app.jar
ENV SERVER_ADDRESS=0.0.0.0
EXPOSE 5000
CMD ["java", "-jar", "app.jar"]

# added on 31st Oct
# ENTRYPOINT [ "sh", "-c", "java -Dspring.profiles.active=prod -jar /usr/local/tomcat/webapps/cicd-demo-0.0.1-SNAPSHOT.war" ]