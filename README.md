# SiaStream

[![Build Status](https://travis-ci.org/nebulouslabs/docker-siastream.svg?branch=master)](https://travis-ci.org/nebulouslabs/docker-siastream) 
[![Docker Pulls](https://img.shields.io/docker/pulls/nebulouslabs/siastream.svg?maxAge=604800)](https://hub.docker.com/r/nebulouslabs/siastream/) 
[![License](http://img.shields.io/:license-mit-blue.svg)](LICENSE)

## Supported Tags

* **latest**: The latest official binary release.

## Usage

SiaStream comes packaged with a small Sia node which it will use internally.
This node needs to sync the blockchain in order for SiaStream to work. This 
takes a significant amount of time and we don't want to lose the data between 
SiaStream restarts. That's why we want to store the synced data in a dedicated
directory that can be mapped to a directory outside of docker via a volume.  

Let's create that directory:
```bash
mkdir sia-data
```

Here is how you start SiaStream:
```bash
docker run \
  --detach \
  --volume $(pwd)/sia-data:/sia \
  --publish 127.0.0.1:3000:3000 \
  --name siastream-container \
   nebulouslabs/siastream
```

In case you're not starting SiaStream from the directory that holds your 
`sia-data` (or the directory is called something else), make sure to replace 
`$(pwd)/sia-data` in the command above with the full path to your `sia-data`.
 
 You can also choose to run SiaStream on a different port by changing the first
 `3000` on the `--publish 127.0.0.1:3000:3000` line or to expose SiaStream on
 your network by publishing to your local IP address (for LAN access) or to 
 `0.0.0.0` for access from all networks.

## Health monitoring

The `siastream` container is equipped with a [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#healthcheck) 
and is labelled as `autoheal=true`. This allows us to use Will Farrel's [autoheal](https://hub.docker.com/r/willfarrell/autoheal/) 
container in order to restart the `siastream` container if it becomes unhealthy.

All you need to do is start the `autoheal` container alongside `siastream`:
```
docker run -d \
    --name autoheal \
    --restart=always \
    -e AUTOHEAL_CONTAINER_LABEL=all \
    -v /var/run/docker.sock:/var/run/docker.sock \
    willfarrell/autoheal
```
