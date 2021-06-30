# Building a Java App with the Docker Tomcat Image

## Environment

Set java option with 'JAVA_OPTS'.

[Learn more about jvm configuration](https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers).

## Build

When some arguments are possible. Below are the defaults values.

```shell
docker build --tag java-app \
  --build-arg UID="8080" \
  --build-arg USER="tomcat" \
  --build-arg GIT_REPO="https://github.com/bluebrown/example-maven-war-app" \
  --build-arg BUILD_TARGET="/maven/target/demo" \
  --build-arg BUILD_CONTEXT="ROOT" \
  .
```

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
  --env JAVA_OPTS="$JAVA_OPTS" \
  
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

Automatic deployment and unpacking of war files has been disabled. We can put the already exploded war file in tomcats webapps folder. That will speed up the start of the container and also lower the attack surface.

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
