ARG VERSION="10"
FROM tomcat:${VERSION}

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

COPY --chown="$UID:$UID" entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
USER $USER
CMD ["catalina.sh", "run"]
