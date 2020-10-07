FROM alpine AS build-gitstage
RUN apk update
RUN apk add git
RUN mkdir /home/taskana && cd /home/taskana && git clone https://github.com/Taskana/taskana.git .
WORKDIR /home/taskana