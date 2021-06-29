FROM maven as builder

WORKDIR /maven
RUN git clone https://github.com/bluebrown/example-maven-war-app .
RUN mvn compile war:exploded


FROM tomcat:10

ARG UID=8080
ARG USER="tomcat"
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home /usr/local/tomcat \
    --no-create-home \
    --uid "$UID" \
    "$USER"

RUN rm -rf webapps.dist

COPY conf conf/
COPY webapps webapps/

HEALTHCHECK \
    --interval=120s \
    --timeout=15s \
    --start-period=120s \
    --retries=3 \
    CMD curl --fail 'localhost:8080/health/alive' || exit 1

COPY --from=builder /maven/src/webapp webapps/app
USER $USER
ENV JAVA_OPTS="\
    -Djava.security.egd=file:/dev/./urandom \
    -XX:ParallelGCThreads=2 \
    -XX:MaxRAM=4G \
    -XX:GCTimeRatio=4 \
    -XX:AdaptiveSizePolicyWeight=90"
