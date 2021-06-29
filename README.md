# Tomcat Custom 10

## Web.xml

### Custom Error Page

```xml
<web-app ...>
    <error-page>
        <!-- catch all  -->
        <location>/error.html</location>
    </error-page>
    <error-page>
    <!-- custom error per code -->
    <error-code>401</error-code>
    <location>/error.html</location>
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
