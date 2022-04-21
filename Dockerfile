FROM openjdk:11

WORKDIR /xmd-eureka-server

VOLUME /tmp 

# ARG JAR_OPENTELEMETRY_AGENT=./opentelemetry_agent/*.jar
COPY ./opentelemetry_agent/*.jar opentelemetry-javaagent.jar

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
COPY entry.sh run.sh

RUN chmod 774 run.sh

RUN ./mvnw install -DskipTests

ENV PROFILE=local


EXPOSE 8761

ENTRYPOINT [ "./run.sh" ]
