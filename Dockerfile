FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY JavaApp-CICD/pom.xml .
COPY JavaApp-CICD/src ./src
COPY JavaApp-CICD/mvnw .
COPY JavaApp-CICD/mvnw.cmd .
RUN mvn clean package -DskipTests
RUN echo "=== JAR ===" && find /app/target -name "*.jar" -not -path "*/dependency/*"

FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
