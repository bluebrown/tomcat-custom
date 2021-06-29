FROM maven as builder

WORKDIR /maven
RUN git clone https://github.com/bluebrown/example-maven-war-app .
RUN mvn compile war:exploded

FROM tomcat-custom
COPY --from=builder /maven/src/webapp webapps/app
CMD ["catalina.sh", "run"]
