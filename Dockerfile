FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY JavaApp-CICD/pom.xml .
COPY JavaApp-CICD/src ./src
RUN mvn clean package -DskipTests
RUN ls -la target/

FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
RUN ls -la /app/
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
