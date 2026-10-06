# Build stage
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests -q

# Runtime stage — Tomcat 10.1 on JDK 17
FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

ENV UPLOAD_DIR=/var/coursecraft/uploads
RUN mkdir -p /var/coursecraft/uploads

EXPOSE 8080
