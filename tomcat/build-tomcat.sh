#!/bin/bash
set -ex
JAVA_HOME=$(find /usr/lib/jvm -name *.h -print -quit | xargs dirname | xargs dirname)
TOMCAT_MAJOR=$1
TOMCAT_VERSION=$2
TOMCAT_SHA512=$3

curl -fL -o 'tomcat.tar.gz' "https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"
echo "$TOMCAT_SHA512 *tomcat.tar.gz" | sha512sum --strict --check -
tar -xf tomcat.tar.gz --strip-components=1
rm bin/*.bat
rm tomcat.tar.gz*

# https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Default_web_applications
rm -r webapps
mkdir webapps
# we don't delete them completely because they're frankly a pain to get back for users who do want them, and they're generally tiny (~7MB)

nativeBuildDir="$(mktemp -d)"
tar -xf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1

export CATALINA_HOME="$PWD"
cd "$nativeBuildDir/native"
aprConfig="$(command -v apr-1-config)"
./configure \
    --libdir="$TOMCAT_NATIVE_LIBDIR" \
    --prefix="$CATALINA_HOME" \
    --with-apr="$aprConfig" \
    --with-java-home="$JAVA_HOME" \

make CFLAGS=-DOPENSSL_SUPPRESS_DEPRECATED -j "$(nproc)"

make install
cd $CATALINA_HOME
rm -rf "$nativeBuildDir"
rm bin/tomcat-native.tar.gz;

chmod -R +rX .
chmod 1777 logs temp work

catalina.sh version
