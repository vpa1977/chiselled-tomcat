#!/bin/sh

docker build -t tomcat-10 \
    --build-arg TOMCAT_MAJOR=10 \
    --build-arg TOMCAT_VERSION=10.1.19 \
    --build-arg TOMCAT_SHA512=7264da6196a510b0bba74469d215d61a464331302239256477f78b6bec067f7f4d90f671b96a440061ae0e20d16b1be8ca1dbd547dab9927383366dbc677f590 \
    tomcat
