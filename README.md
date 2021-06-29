# Tomcat Custom 10

## Run

```shell
docker run \
  --rm \
  --name tomcat \
  --port 80:8080 \
  --log-driver local \
  --log-opt mode=non-blocking \
  --log-opt max-buffer-size=4m \
  tomcat-custom:10
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

Both logger, `catalina` and `localhost` have been configured to drop the oldest message in the buffer if its full before the logger hand the chance to write. Additionally the buffer size has been reduced to 250 messages so it would drop more frequently but not hold as much data in memory.

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
