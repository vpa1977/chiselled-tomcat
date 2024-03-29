ARG UBUNTU_RELEASE=22.04
ARG BASE_IMAGE=ubuntu/jre:17_edge
FROM golang:1.22 AS chisel
ARG UBUNTU_RELEASE

RUN git clone  --depth 1 -b ubuntu-22.04 https://github.com/canonical/chisel-releases /opt/chisel-releases \
    && git clone --depth 1 -b main https://github.com/canonical/chisel /opt/chisel
WORKDIR /opt/chisel
RUN go generate internal/deb/version.go \
    && go build ./cmd/chisel

FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:722b3bddfe96b95441f626cf94974d79213090ecbd16954f71d7c080fb413561 AS builder
ARG TOMCAT_MAJOR=10
ARG TOMCAT_VERSION=10.1.19
ARG TOMCAT_SHA512=cfdc182e62b33b98ce61f084f51c9cf0bcc5e5f4fff341d6e8bcb7c54b12c058faa2e164a587100ba1c6172b9ae2b32ff4a7193a859b368d1f67baca6aa1680f

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates \
        ca-certificates-java \
        binutils \
        openjdk-17-jdk \
        libapr1 \
        openssl \
        libssl3 \
        gcc \
        make \
        libapr1-dev \
        libssl-dev \
        curl \
        busybox \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
COPY --from=chisel /opt/chisel/chisel /usr/bin/

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR
ADD build-tomcat.sh /
RUN /build-tomcat.sh $TOMCAT_MAJOR $TOMCAT_VERSION $TOMCAT_SHA512
RUN rm /build-tomcat.sh

FROM builder as sliced-deps

COPY --from=chisel /opt/chisel-releases /opt/chisel-releases
RUN mkdir -p /rootfs \
    && chisel cut --release /opt/chisel-releases --root /rootfs \
        openssl_bins \
        libapr1_libs \
        busybox_bins

# configure busybox applets
RUN cd /rootfs/bin && for applet in $(busybox --list); do \
      ln -s busybox $applet ; \
    done

RUN mkdir -p /rootfs/usr/local/tomcat \
    && cp -rp /usr/local/tomcat/* /rootfs/usr/local/tomcat/

FROM $BASE_IMAGE
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR
COPY --from=sliced-deps /rootfs /

# verify Tomcat Native is working properly
RUN set -eux; \
    nativeLines="$(catalina.sh configtest 2>&1)"; \
    if ! echo "$nativeLines" | grep 'Loaded Apache Tomcat Native library' >&2; then \
        echo >&2 "$nativeLines"; \
        exit 1; \
    fi

EXPOSE 8080

ENTRYPOINT ["/bin/busybox", "sh"]
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
