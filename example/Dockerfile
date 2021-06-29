FROM maven as builder

WORKDIR /maven
RUN git clone https://github.com/bluebrown/example-maven-war-app .
RUN mvn compile war:exploded

FROM rjtest.concentrix.com:5443/tomcat10-custom:1.1
COPY --from=builder /maven/src/webapp webapps/app
CMD ["catalina.sh", "run"]
