# XMD Eureka Server Service



### 도커 이미지 만들기
```bash 
docker build -t xmdeurekasvc:0.1 .    
```

### docker 컨테이너  start 
```bash
docker run --name xmd-eureka-server -p 8761:8761 -e "PROFILE=dev" -e "OTEL_EXPORTER_OTLP_ENDPOINT=192.168.219.103" xmdeurekasvc:0.1  
```


