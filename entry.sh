#!/bin/sh

ACTIVE_PROFILE="${PROFILE:-dev}"

echo "ACTIVE_PROFILE=${ACTIVE_PROFILE}"

exec java -javaagent:./opentelemetry-javaagent.jar \
          -Dotel.exporter.otlp.endpoint=http://192.168.10.157:4317 \
          -Dotel.resource.attributes=service.name=xmd-Eureka-server \
          -Dspring.profiles.active=${ACTIVE_PROFILE} \
          -jar target/EurekaServer-0.0.1-SNAPSHOT.jar