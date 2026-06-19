# Pin node:22-alpine by digest. The mutable tag rolled to Node 22.23.0 on 2026-06-18
# (June security release: undici/http.Agent/TLS changes) which broke firebase-tools auth.
# Last-known-good image, used by passing daily builds on 2026-06-17.
FROM node:22-alpine@sha256:e58326d0d441090181ac150dc2078d3e2cf6a0d42e809aebba3ef5880935ffdd

WORKDIR /app
COPY . /app

RUN apk update \
    && apk add bash git g++ make python3 \
    && yarn global add firebase-tools@15.17.0

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]
