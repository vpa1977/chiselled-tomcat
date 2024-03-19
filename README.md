# Chiselled tomcat container

## Building

Run `./build-tomcat-9.sh` to build the `chiselled-tomcat-9` container.
It builds a chiselled Ubuntu 22.04 container running Java 8 and Tomcat 9.0.87.

Run `./build-tomcat-9.sh` to build `chiselled-tomcat-10` container.
It builds a chiselled Ubuntu 22.04 container running Java 17 and Tomcat 10.0.19.

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
