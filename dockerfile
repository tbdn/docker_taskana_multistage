FROM openjdk:8-jdk-alpine AS buildstage
RUN apk update
RUN apk add git maven npm
RUN mkdir /home/taskana && cd /home/taskana && git clone -b dockerized https://github.com/tbdn/taskana.git .

WORKDIR /home/taskana
RUN mvn clean install

WORKDIR /home/taskana/web
RUN npm install 
RUN npm install -g @angular/cli@latest
RUN npm run build:prod

FROM buildstage AS target-stage
FROM openjdk:8-jre-alpine
RUN mkdir /home/taskana
WORKDIR /home/taskana
EXPOSE 8080
COPY --from=buildstage /home/taskana/rest/taskana-rest-spring-example-boot/target/taskana-rest-spring-example-boot.jar /home/taskana/taskana.jar
ENTRYPOINT ["java", "-jar", "taskana.jar"]