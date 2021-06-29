# Tomcat Custom 10

## web.xml

### Custom Error Page

Under webapp/errors custom error pages can be placed. By default a generic error is served from the index.html deployed there.

```xml
<web-app ...>
    <error-page>
        <!-- catch all  -->
        <location>/error/</location>
    </error-page>
    <error-page>
    <!-- custom error per code -->
    <error-code>401</error-code>
    <location>/error/401.html</location>
</error-page>
</web-app>
```

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

## Health Checks

There are two files Under webapp/health/. `/ready` and `/alive`.

The application developer should still create their own liveliness and readiness endpoints as this only reflects if tomcat is generally still running and able to serve content.
