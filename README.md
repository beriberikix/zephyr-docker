# Docker containers for the Zephyr RTOS

[![Dev Container](https://github.com/beriberikix/zephyr-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/beriberikix/zephyr-docker/actions/workflows/docker-publish.yml)

Develop Zephyr applications locally using Docker. No other tools required* besides `docker` & `git`! The container image includes all the tools needed to fetch, build, flash & debug, while your source code can stay on your local machine.

*_mostly_, depends on OS.

# Getting container images

## Build images locally

Building images locally ensures you can trust the source of the image, as well as allow you to modify the container image configuration.

### Building with Docker CLI

_To build an image for v3.2.0 and Arm Cortex-M targets:_

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.16.0 --build-arg ZEPHYR_VERSION=v3.2.0 --build-arg TOOLCHAIN=arm-zephyr-eabi -t zephyr-arm:v3.2.0-0.16.0sdk .
```

_To build an image for main that supports every target:_

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.16.0 --build-arg ZEPHYR_VERSION=main --build-arg TOOLCHAIN=all -t zephyr-all:main-0.16.0sdk .
```

This follows a label convention of ZEPHYR_VERSION-ZEPHYR_SDK_VERSION. It will be a _large_ image since it pulls in every toolchain (~6GB.)

> :warning: Experimental: Smaller images with Alpine

Alpine Linux is a lightweight Linux distro that's commonly used as the basis of Docker containers to reduce their size. In order to build a container image image using Alpine instead of Debian:

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.16.0 --build-arg ZEPHYR_VERSION=v3.2.0 --build-arg TOOLCHAIN=arm-zephyr-eabi -t zephyr-arm:alpine-v3.2.0-0.16.0sdk -f Dockerfile.alpine .
```

### Important build arguments

* ARCHITECTURE - Architecture for the container host OS. Not to be confused with target architecture.
* ZEPHYR_SDK_VERSION - SDK version. Must be 0.14.1 or later.
* ZEPHYR_VERSION - Zephyr version. Can be a tag or branch, including `main`
* TOOLCHAIN - target toolchain.

If some or none of the arguments are missing the build will default to a recent stable version.

## Download prebuilt images

Prebuilt container images can be used instead of having to build locally. Prebuilts are created using Github Actions daily and hosted on the Github Container Registry.

Each container image supports a single target architecture and is a separate package. For example, the `arm` package is `zephyr-arm`. Additionally, different versions of Zephyr and Zephyr SDK are seperated with labels. See all packages [here](https://github.com/beriberikix?tab=packages&repo_name=zephyr-docker).

Install from the commandline:

```
docker pull ghcr.io/beriberikix/zephyr-arm:main-0.16.0sdk
```

Use as a base image in a Dockerfile:

```
FROM ghcr.io/beriberikix/zephyr-arm:main-0.16.0sdk
```

# Develop with Docker

The container image can be used to build any compatible Zephyr application, including in-tree samples or custom application. There are several ways to use a Docker container for development.

## Interactive mode

A container can be used in a like you would use a Virtual Machine. Here is an example following the official Getting Started Guide but with much less setup.

```
docker run -it --name zephyr-gsg ghcr.io/beriberikix/zephyr-arm:main-0.16.0sdk
west init ~/zephyrproject
cd ~/zephyrproject
west update
west zephyr-export
cd ~/zephyrproject/zephyr
west build -b mimxrt1060_evkb samples/basic/minimal -p
exit
```

The container will stop after you `exit` and will remain on your machine in the previous state (again, like a VM.) To restart the container where you left off use `docker start.`

Using the GSG example:

```
docker start -ia zephyr-gsg
```
## Seamless mode

TODO

## GitHub Actions

TOOD

# Notes

1. Currently only supports local development. CI integration planned for the future.
2. Supports Zephyr SDK 0.16.0 and later.
3. Pre-builts currently only target x86_64 hosts.

# Acknowledgement

Special thanks to the ZMK maintainers. This implementation was originally based on [zmk-docker](https://github.com/zmkfirmware/zmk-docker) but has since been re-written.
