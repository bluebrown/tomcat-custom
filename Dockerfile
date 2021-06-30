FROM maven as builder

WORKDIR /maven
ARG GIT_REPO="https://github.com/bluebrown/example-maven-war-app"
RUN git clone "$GIT_REPO" .
RUN mvn compile war:exploded 


FROM tomcat

ARG UID=8080
ARG USER="tomcat"
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home /usr/local/tomcat \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

RUN rm -rf webapps.dist

COPY conf conf/
COPY webapps webapps/

HEALTHCHECK \
    --interval=30s \
    --timeout=30s \
    --start-period=30s \
    --retries=3 \
    CMD curl -I --fail 'localhost:8080/health/alive' || exit 1

USER $USER
ARG BUILD_CONTEXT="ROOT"
ARG BUILD_TARGET="target/demo"
COPY --from=builder "/maven/$BUILD_TARGET" "webapps/$BUILD_CONTEXT"

