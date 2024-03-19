ARG UBUNTU_RELEASE=22.04
ARG BASE_IMAGE=chiselled-tomcat-10

FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:722b3bddfe96b95441f626cf94974d79213090ecbd16954f71d7c080fb413561 AS builder
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates \
        ca-certificates-java \
        binutils \
        openjdk-17-jdk-headless \
        maven
ADD web /web
RUN (cd /web && mvn package)

FROM $BASE_IMAGE

COPY --from=builder /web/target/web-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps
ADD config/server.xml /usr/local/tomcat/conf/server.xml
