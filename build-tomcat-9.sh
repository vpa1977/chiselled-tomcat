#!/bin/sh

docker build -t chiselled-tomcat-9 \
    --build-arg TOMCAT_MAJOR=9 \
    --build-arg TOMCAT_VERSION=9.0.87 \
    --build-arg TOMCAT_SHA512=71a64fe805aab89ef4798571d860a3c9a4f751f808921559a9249305abb205836de33ab89bb33b625a77f799f193d6bffbe94aadf293866df756d708f5bfb933 \
    --build-arg BASE_IMAGE=ubuntu/jre:8_edge \
    tomcat
