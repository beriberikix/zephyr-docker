# Zephyr Docker

[![Dev Container](https://github.com/beriberikix/zephyr-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/beriberikix/zephyr-docker/actions/workflows/docker-publish.yml)

Develop Zephyr applications locally using optimized Docker containers.

# How to use pre-built containers

Pre-built containers can be used instead of having to build locally. Pre-builts are created using Github Actions and rebuilt daily.

Each container supports a single target architecture and is a separate package. For example, the `arm` package is `zephyr-arm`. Additionally, different versions of Zephyr and Zephyr SDK are seperated with labels. See all packages [here](https://github.com/beriberikix?tab=packages&repo_name=zephyr-docker).

Install from the commandline:

```
docker pull ghcr.io/beriberikix/zephyr-arm:main-0.15.2SDK
```

Use as base image in Dockerfile:

```
FROM ghcr.io/beriberikix/zephyr-arm:main-0.15.2SDK
```

# Build images

Docker images can also be built locally.

## Important build arguments

* ARCHITECTURE - Architecture for the docker container. Not to be confused with target architecture.
* ZEPHYR_SDK_VERSION - SDK version. Must be 0.15.2 or later.
* ZEPHYR_VERSION - Zephyr version. Can be a tag or branch, including `main`
* TOOLCHAIN - target toolchain.

If some or none of the arguments are missing the build will default to a recent stable version.

## Building with Docker CLI

_To build an image for v3.2.0 and Arm Cortex-M targets:_

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.15.2 --build-arg ZEPHYR_VERSION=v3.2.0 --build-arg TOOLCHAIN=arm-zephyr-eabi -t zephyr-arm:v3.2.0-0.15.2SDK .
```

_To build an image for main that supports every target:_

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.15.2 --build-arg ZEPHYR_VERSION=main --build-arg TOOLCHAIN=all -t zephyr-all:main-0.15.2SDK .
```

This follows a label convention of ZEPHYR_VERSION-ZEPHYR_SDK_VERSION. It will be a _large_ image since it pulls in every toolchain (~6GB.)

### Notes

1. Currently only supports local development. CI integration planned for the future.
2. Supports Zephyr SDK 0.15.2 and later.
3. Pre-builts currently only target x86_64 hosts.

### Acknowledgement

Special thanks to the ZMK maintainers. This implementation was originally based on [zmk-docker](https://github.com/zmkfirmware/zmk-docker) but has since been re-written.
