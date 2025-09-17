# Use a more secure Java base image
FROM eclipse-temurin:17-jre-alpine

# https://medium.com/@skywalkerhunter/aws-docker-deploy-spring-boot-fe05a00191d9
# added on 31st Oct
LABEL maintainer="Darryl Ng <darryl1975@hotmail.com>"
LABEL description="Dockerfile for deploying to Beanstalk needs dockerrun.aws.json"

# added on 31st Oct
#RUN rm -rf /usr/local/tomcat/webapps/*

# Create a non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Set the working directory to /app
WORKDIR /app

# Copy the Spring Boot application JAR file into the Docker image
COPY target/cicd-demo-0.0.1-SNAPSHOT.jar /app/cicd-demo-0.0.1-SNAPSHOT.jar

# Change ownership of the app directory to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Set JVM security options for a more secure runtime
ENV JAVA_OPTS="-Djava.awt.headless=true \
               -Dfile.encoding=UTF-8 \
               -Djava.security.egd=file:/dev/./urandom \
               -Dspring.profiles.active=production"

# Expose the port that the Spring Boot application will run on
EXPOSE 5000

# Define health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:5000/ || exit 1

# Set the command to run the Spring Boot application
CMD ["sh", "-c", "java $JAVA_OPTS -jar /app/cicd-demo-0.0.1-SNAPSHOT.jar"]