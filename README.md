# NHN크로센트 tech-interview 과제
Spring 기반 자바 어플리케이션을 컨테이너로 전환하고 Kubernetes에 배포

# Docker hub 이미지 등록
- #### public repository 생성
  * repository: sewook0204/spring-petclinic
  * https://hub.docker.com/repository/docker/sewook0204/spring-petclinic/general
<img width="1440" alt="image" src="https://github.com/lemonyone/tech-interview/assets/116869373/67c3b92a-51b9-442b-8abc-e6c3cf3ca159">


- #### Dockerfile 생성  
``` Dockerfile  
FROM openjdk:17   
CMD ["./mvnw", "clean", "package"]  
ARG JAR_FILE=./target/*.jar
COPY ${JAR_FILE} petclinic.jar  
ENTRYPOINT ["java","-jar","petclinic.jar"]  
```
- docker image build  
  * docker build -t sewook0204/spring-petclinic:1.0.3  
- docker image 동작 확인
  * docker run -d -p 8080:8080 sewook0204/spring-petclinic:1.0.3  
- docker image push
  * docker push sewook0204/spring-petclinic:1.0.3
 
# yaml 파일 생성  
- ingress-petclinic.yaml  
```yaml  
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: petclinic
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: tech1.nks.msxpert.co.kr
    http:
      paths:
      - path: "/"
        pathType: Prefix
        backend:
          service:
             name: petclinic
             port:
               number: 80  
```  
- service-petclinic.yaml
```yaml  
apiVersion: v1
kind: Service
metadata:
  name: petclinic
spec:
  type: ClusterIP
  selector:
    app: petclinic
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080  
```
- deployment-petclinic.yaml
```yaml  
kind: Deployment
metadata:
  name: petclinic
spec:
  replicas: 1
  selector:
    matchLabels:
      app: petclinic
  template:
    metadata:
      labels:
        app: petclinic
    spec:
      containers:
       - name: petclinic
         image: sewook0204/spring-petclinic:1.0.3
         ports:
           - containerPort: 8080
         resources:
           requests:
             cpu: "1m"
             memory: "100Mi"
           limits:
             cpu: "1m"
             memory: "500Mi"  
```  
# 실행  
- kubeconfig
  * ~/.kube/config에 적용
    
- default namespace 변경
  * kubectl config set-context --current --namespace=tech1

- ingress, service, deployment 생성
  * kubectl apply -f ingress-petclinic.yaml  
  * kubectl apply -f service-petclinic.yaml  
  * kubectl apply -f deployment-petclinic.yaml  
  
# 실행 결과
- ingress
  * kubectl get ing petclinic  
  * kubectl describe ing petclinic
<img width="1287" alt="image" src="https://github.com/lemonyone/tech-interview/assets/116869373/21ed28a4-2702-42c7-b9cd-37284253c4d5">  
  
- service  
  * kubectl get svc petclinic  
  * kubectl describe ing petclinic  
<img width="1287" alt="image" src="https://github.com/lemonyone/tech-interview/assets/116869373/93bf6e95-69ac-494d-bce3-8e2b2dd97fd2">

- deployment
  * kubectl get deploy petclinic
  * kubectl describe deploy petclinic  
<img width="1284" alt="image" src="https://github.com/lemonyone/tech-interview/assets/116869373/e53aab9c-bda2-4c5b-9036-1e1cdbdbf2c7">

- pod
  * kubectl get pod petclinic-7bb5d498cc-knfcl
  * kubectl describe pod petclinic-7bb5d498cc-knfcl
<img width="964" alt="image" src="https://github.com/lemonyone/tech-interview/assets/116869373/386ba772-f6f0-451d-b650-345b5ed85274">

- pod 로그 확인 - application 정상 동작 확인
  * kubectl logs petclinic-7bb5d498cc-knfcl
<img width="1421" alt="image" src="https://github.com/lemonyone/tech-interview/assets/116869373/848ff967-b318-4a7c-95ec-f0262cabe875">

- 브라우저 접속 화면
  * url: http://tech1.nks.msxpert.co.kr
<img width="1439" alt="image" src="https://github.com/lemonyone/tech-interview/assets/116869373/cfe2352c-9e0c-4c28-a9fa-7183838e5cb3">























































   
