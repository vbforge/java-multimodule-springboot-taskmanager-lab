# VERSION - 1
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/version3-mysql-docker-1.0.0.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]

