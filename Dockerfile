FROM node:12.18 AS builder

RUN git clone https://gitlab.com/NebulousLabs/siastream.git && \
    cd siastream && \
    yarn && \
    yarn build && \
    yarn package linux

FROM debian:stretch-slim
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"
LABEL autoheal=true

WORKDIR /siastream

COPY --from=builder /siastream/dist/siastream-linux-x64/ ./
COPY run.sh .

RUN apt-get update && apt-get install -y fuse && \
    chmod +x ./siastream

ARG EXT_SIAD_HOST=""
ARG EXT_SIAD_PORT=""
ENV EXT_SIAD_HOST="$EXT_SIAD_HOST"
ENV EXT_SIAD_PORT="$EXT_SIAD_PORT"

EXPOSE 3000

ENTRYPOINT ["./run.sh"]
