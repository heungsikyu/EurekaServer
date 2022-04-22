#!/bin/sh

ACTIVE_PROFILE="${PROFILE:-dev}"
ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT="${OTEL_EXPORTER_OTLP_ENDPOINT:-127.0.0.1}"

#ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT="http://${OTEL_EXPORTER_OTLP_ENDPOINT}:4317"

echo "ACTIVE_PROFILE=${ACTIVE_PROFILE}"
echo "ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT=${ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT}"

exec java -javaagent:./opentelemetry-javaagent.jar \
          -Dotel.exporter.otlp.endpoint=http://${ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT}:4317 \
          -Dotel.resource.attributes=service.name=xmd-Eureka-server \
          -Dspring.profiles.active=${ACTIVE_PROFILE} \
          -jar target/EurekaServer-0.0.1-SNAPSHOT.jar