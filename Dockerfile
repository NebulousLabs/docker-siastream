FROM node:14.8.0-stretch-slim

LABEL maintainer="NebulousLabs <devs@nebulous.tech>"
LABEL autoheal=true

RUN apt-get update -qq && apt-get install -qq fuse
RUN npm install -g siastream

COPY run.sh .

ARG EXT_SIAD_HOST=""
ARG EXT_SIAD_PORT=""
ENV EXT_SIAD_HOST="$EXT_SIAD_HOST"
ENV EXT_SIAD_PORT="$EXT_SIAD_PORT"

EXPOSE 3000

ENTRYPOINT ["./run.sh"]
