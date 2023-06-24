FROM openjdk:17
CMD ["./mvnw", "clean", "package"]
ARG JAR_FILE=./target/*.jar
COPY ${JAR_FILE} petclinic.jar
ENTRYPOINT ["java","-jar","petclinic.jar"]
