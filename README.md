# Tomcat Custom 10

## Building a User Image

```Dockerfile
FROM maven as builder

WORKDIR /maven
RUN git clone https://github.com/bluebrown/example-maven-war-app .
RUN mvn compile war:exploded

FROM bluebrown/tomcat-custom
COPY --from=builder /maven/src/webapp webapps/app
```

### Environment

Set java option with 'JAVA_OPTS'.

[Learn more about jvm configuration](https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers).

## Run

```shell
JAVA_OPTS="-XX:ParallelGCThreads=2 \
    -XX:MaxRAM=2G \
    -XX:GCTimeRatio=4 \
    -XX:AdaptiveSizePolicyWeight=90"

docker run \
  --rm \
  --name java-app \
    -p 80:8080 \
  --log-driver local \
  --log-opt mode=non-blocking \
  --log-opt max-buffer-size=4m \
  --env JAVA_OPTS="$JAVA_OPTS"
  java-app
```

## web.xml

### Settings

The following servlet settings have been made over the defaults. `ctrl-f` for the right place in the file.

Field                   | Set Value to
------------------------|--------------
showServerInfo          | false
classdebuginfo          | false
development             | false
genStringAsCharArray    | true
mappedfile              | false
trimSpaces              | true

## server.xml

Automatic deployment and unpacking of war files has been disabled.

```xml
<Host name="localhost"  appBase="webapps" 
    unpackWARs="false" autoDeploy="false">
```

### Custom Error Page

Errors pages have been *masked* by using [ErrorReportValve](https://tomcat.apache.org/tomcat-9.0-doc/config/valve.html#Error_Report_Valve).

```xml
<Valve 
    className="org.apache.catalina.valves.ErrorReportValve"
    errorCode.0="errors/index.html" 
    errorCode.404="errors/404.html" 
    showReport="false"
    showServerInfo="false"
  />
```

You can configure specific error pages by using `errorCode.n` i.e. `errorCode.404`.

## logging.properties

All logger, 'console`,`catalina` and `localhost` have been configured to drop the oldest message in the buffer if its full before the logger hand the chance to write. Additionally the buffer size has been reduced to 250 messages so it would drop more frequently but not hold as much data in memory.

These settings are in `logging.properties`.

```ini
...
AsyncFileHandler.AsyncOverflowDropType = 2
AsyncFileHandler.AsyncMaxRecordCount = 250
...
```

See [System Properties](https://tomcat.apache.org/tomcat-8.5-doc/config/systemprops.html#Logging)

## Health Checks

There are two files Under `${HOST}/health`. `/ready` and `/alive`.

The application developer should still create their own liveliness and readiness endpoints as this only reflects if tomcat is generally still running and able to serve content.
