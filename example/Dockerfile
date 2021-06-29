FROM maven as builder

WORKDIR /maven
RUN git clone https://github.com/bluebrown/example-maven-war-app .
RUN mvn compile war:exploded

FROM bluebrown/tomcat10-custom:1.1
COPY --from=builder /maven/src/webapp webapps/app
