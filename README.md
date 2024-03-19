# Tomcat in a chiselled jre container

This repository contains a docker file to deploy tomcat in a chiselled jre image.

Image size comparison:

| Image              | Tag | Size (Uncompressed) | % vs official image|
|--------------------|-----|---------------------|--------------------|
|chiselled-tomcat-10 |  latest       |  149MB    | 51%                 |
|tomcat              |  10.1.19-jre17| 288MB     | -                  |
|chiselled-tomcat-9  |  latest       | 131MB     | 53%          |
|tomcat              |  9.0.87-jre8  | 243MB     |- |

## Building

Run `./build-tomcat-9.sh` to build the `chiselled-tomcat-9` container.
It builds a chiselled Ubuntu 22.04 container running Java 8 and Tomcat 9.0.87.

Run `./build-tomcat-9.sh` to build `chiselled-tomcat-10` container.
It builds a chiselled Ubuntu 22.04 container running Java 17 and Tomcat 10.1.19.

## Deploying an application

### Adding your application

This is a minimal docker file to add your web application to the chiselled Tomcat container:

```
FROM chiselled-tomcat-10
ADD your-web-app.war /usr/local/tomcat/webapps
ADD your-tomcat-server.xml /usr/local/tomcat/conf/server.xml
```

See `sample/Dockerfile` for the working example.

### Sample

`sample` directory contains a simple example of deploying a web application to the chiselled container.

It contains tomcat configuration in `sample/config/server.xml` and a Spring Boot starter app.

To build the sample run

`docker build -t sample sample`

Run the sample:

`docker run -p 8080:8080 sample`

Navigate to `http://localhost:8080/greeting` to see the output.
