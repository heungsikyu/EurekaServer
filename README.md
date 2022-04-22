# XMD Eureka Server Service 
## 로컬 호스트에서 서비스 시작 vs 도커 컨테이너로 서비스 시작 

### 1. 로컬 호스트에서 서비스 시작

#### 1.1 컴파일 
maven으로 프로젝트를 만들었기에 gradle build 방식과 컴파일 방식이 다르다. 
__기존 소스가 있다면 삭제 한다.__ 
 ```bash
    ./mvnw clean 
 ```
  __maven을 통한 컴파일 및 jar 파일 생성__ 
 
  ```bash
    ./mvnw package 
 ```

#### 1.2 서비스 시작 
각자 환경에 맞춰서 셋팅한다. 
  http://{signoz install ip}:4317

```bash
OTEL_EXPORTER_OTLP_ENDPOINT="http://{signoz install ip}:4317" OTEL_RESOURCE_ATTRIBUTES=service.name=xmd-eureka-server \
java -javaagent:/Users/{사용자ID}/xmd/opentelemetry_agent/opentelemetry-javaagent.jar \
-jar /Users/{사용자ID}/xmd/EurekaServer/target/EurekaServer-0.0.1-SNAPSHOT.jar
```

----
### 2. 도커 컨테이너로 서비스 시작  

#### 2.1 필요한 파일 생성

 - __도커 파일 생성 :  Dockerfile__
  
```yaml
    FROM openjdk:11

    WORKDIR /app

    VOLUME /tmp 

    COPY ./opentelemetry_agent/*.jar opentelemetry-javaagent.jar

    COPY mvnw .
    COPY .mvn .mvn
    COPY pom.xml .
    COPY src src
    COPY entry.sh run.sh

    RUN chmod 774 run.sh

    RUN ./mvnw install -DskipTests

    ENV PROFILE="local"
    ENV OTEL_EXPORTER_OTLP_ENDPOINT="127.0.0.1"

    EXPOSE 8761

    ENTRYPOINT [ "./run.sh" ]
```

- __컨테이너 안에서 실행할 shell 프로그램 생성 : entry.sh__

  ```bash 
    #!/bin/sh
    
    ACTIVE_PROFILE="${PROFILE:-dev}"
    ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT="${OTEL_EXPORTER_OTLP_ENDPOINT:-127.0.0.1}"

    echo "ACTIVE_PROFILE=${ACTIVE_PROFILE}"
    echo "ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT=${ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT}"

    exec java -javaagent:./opentelemetry-javaagent.jar \
          -Dotel.exporter.otlp.endpoint=http://${ACTIVE_OTEL_EXPORTER_OTLP_ENDPOINT}:4317 \
          -Dotel.resource.attributes=service.name=xmd-Eureka-server \
          -Dspring.profiles.active=${ACTIVE_PROFILE} \
          -jar target/EurekaServer-0.0.1-SNAPSHOT.jar
  ```

#### 2.2 docker 이미지 만들기  

```bash
docker build -t xmdeurekasvc:0.1 .    
```


#### 2.2 docker 이미지로 xmd-eureka-server 컨테이너 시작
```bash
docker run --name xmd-eureka-server -p 8761:8761 -e "PROFILE=dev" -e "OTEL_EXPORTER_OTLP_ENDPOINT=192.168.219.103" xmdeurekasvc:0.1  
```


