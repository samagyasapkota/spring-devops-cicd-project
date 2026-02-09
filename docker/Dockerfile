# Multi-stage build for Spring PetClinic

# Stage 1: Build
FROM maven:3.8.6-openjdk-11-slim AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY JavaApp-CICD/pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY JavaApp-CICD/src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM tomcat:9.0-jdk11-openjdk-slim
WORKDIR /usr/local/tomcat

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/petclinic.war

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/petclinic/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
