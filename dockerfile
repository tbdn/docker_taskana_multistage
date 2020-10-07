FROM alpine AS build-gitstage
RUN apk update
RUN apk add git
RUN mkdir /home/taskana && cd /home/taskana && git clone https://github.com/Taskana/taskana.git .
WORKDIR /home/taskana

FROM build-gitstage AS build-mavenstage
FROM alpine
COPY --from=build-mavenstage . .
RUN apk update

# https://hub.docker.com/r/masstroy/alpine-docker-java-maven/dockerfile
# install java based on https://github.com/docker-library/openjdk/blob/4e39684901490c13eaef7892c44e39043d7c4bed/8-jdk/alpine/Dockerfile
RUN { \
                echo '#!/bin/sh'; \
                echo 'set -e'; \
                echo; \
                echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
        } > /usr/local/bin/docker-java-home \
        && chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION 8u121
ENV JAVA_ALPINE_VERSION 8.252.09-r0
RUN set -x \
        && apk add --no-cache \
                openjdk8="$JAVA_ALPINE_VERSION" \
        && [ "$JAVA_HOME" = "$(docker-java-home)" ]

RUN apk add maven
RUN apk add npm