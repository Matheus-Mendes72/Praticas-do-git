# Estágio 1: Build (Maven com JDK 21)
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml /app/
COPY src /app/src/

RUN mvn clean install -DskipTests

# Estágio 2: Runtime (JRE leve do Java 21)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]