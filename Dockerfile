FROM amd64/docker:23.0.1-git

# general utils
RUN apk update && apk upgrade && \
    apk add --no-cache curl wget bash tree tar gcompat protoc

# Install sbt
ENV SBT_VERSION 0.13.18
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin

RUN curl -sL "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | gunzip | tar -x -C /usr/local

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools


# Install python packages for build scripts.
RUN pip3 install sh


# Install Java.
RUN apk update && apk upgrade && \
    apk add --no-cache openjdk8

# Install alpine-pkg-glibc (needed to build scala projects with protobuf.jar plugin)
RUN apk update && apk upgrade && \
    apk add --no-cache ca-certificates openssl && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk && \
    apk add glibc-2.35-r0.apk --force-overwrite

RUN apk update && apk upgrade && \
    apk add --no-cache gzip tar

# install awscli
RUN pip3 install awscli
