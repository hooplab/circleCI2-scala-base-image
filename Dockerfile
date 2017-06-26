FROM docker:17.06.0-ce-git
MAINTAINER Halvor Granskogen Bjørnstad <halvor@hoopla.no>

# general utils
RUN apk update && apk upgrade && \
    apk add --no-cache curl wget bash tree

# Install sbt
ENV SBT_VERSION 0.13.11
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin

RUN curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local

# Install python2.7 and upgrade python-pip
RUN apk update && apk upgrade && \
    apk add --no-cache python && \
    wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py


# Install python packages for build scripts.
RUN pip install sh && \
    pip install logging && \
    pip install setuptools


# Install Java.
RUN apk update && apk upgrade && \
    apk add --no-cache openjdk8

# Install alpine-pkg-glibc (needed to build scala projects with protobuf.jar plugin)
RUN apk update && apk upgrade && \
    apk add --no-cache ca-certificates openssl && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk

RUN apk update && apk upgrade && \
    apk add --no-cache gzip tar

# postgres: install
RUN apk update && apk upgrade && \
    apk add --no-cache postgresql postgresql-contrib postgresql-plpython2

# postgres prepare database
RUN mkdir -p /run/postgresql && \
    chown -R postgres:postgres /run/postgresql/ && \
    su - postgres -c 'initdb -D /var/lib/postgresql/data' && \
    su - postgres -c 'pg_ctl start -w -D /var/lib/postgresql/data' && \
    su - postgres -c 'createuser -s hoopla_test' && \
    su - postgres -c 'createdb -O hoopla_test hoopla_test' &&\
    su - postgres -c 'pg_ctl stop -w -D /var/lib/postgresql/data'


# install awscli
RUN pip install awscli
