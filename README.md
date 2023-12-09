# Docker containers for the Zephyr RTOS

[![Dev Container](https://github.com/beriberikix/zephyr-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/beriberikix/zephyr-docker/actions/workflows/docker-publish.yml)

Develop Zephyr applications locally using Docker. No other tools required* besides `docker` & `git`! The container image includes all the tools needed to fetch, build, flash & debug, while your source code can stay on your local machine.

*_mostly_, depends on OS.

# Getting container images

## Build images locally

Building images locally ensures you can trust the source of the image, as well as allow you to modify the container image configuration.

### Building with Docker CLI

_To build an image for Arm Cortex-M targets:_

```
docker build --build-arg ZEPHYR_SDK_TOOLCHAINS="-t arm-zephyr-eabi" --build-arg ZEPHYR_SDK_VERSION=0.16.4 -t zephyr:arm-0.16.4sdk .
```

_To build an image for multiple toolchains:_

```
docker build --build-arg ZEPHYR_SDK_TOOLCHAINS="-t arm-zephyr-eabi -t x86_64-zephyr-elf" --build-arg ZEPHYR_SDK_VERSION=0.16.4 -t zephyr:arm_x86-0.16.4sdk .
```

> :warning: Experimental: Smaller images with Alpine

Alpine Linux is a lightweight Linux distro that's commonly used as the basis of Docker containers to reduce their size. In order to build a container image image using Alpine instead of Debian:

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.16.0 --build-arg ZEPHYR_VERSION=v3.2.0 --build-arg TOOLCHAIN=arm-zephyr-eabi -t zephyr-arm:alpine-v3.2.0-0.16.0sdk -f Dockerfile.alpine .
```

### Important build arguments

* ZEPHYR_SDK_VERSION - SDK version. Must be 0.14.1 or later. Default 0.16.4.
* ZEPHYR_SDK_TOOLCHAINS - target toolchain. Default arm.

## Download prebuilt images

Prebuilt container images can be used instead of having to build locally. Prebuilts are created using Github Actions daily and hosted on the Github Container Registry.

Each container image supports a single target architecture under the `zephyr` package. See all packages [here](https://github.com/beriberikix/zephyr-docker/pkgs/container/zephyr).

NOTE: Previously images were tagged like `zephyr-arm` and had a different implementation. The old images are incompatible with the new images but previous versions are kept around for backwards compatibility.

Install from the commandline:

```
docker pull ghcr.io/beriberikix/zephyr:arm-0.16.4sdk
```

Use as a base image in a Dockerfile:

```
FROM ghcr.io/beriberikix/zephyr:arm-0.16.4sdk
```

# Develop with Docker

The container image can be used to build any compatible Zephyr application, including in-tree samples or custom application. There are several ways to use a Docker container for development.

## Interactive mode

A container can be used in a like you would use a Virtual Machine. Here is an example following the official Getting Started Guide but with much less setup.

```
docker run -it --name zephyr-gsg ghcr.io/beriberikix/zephyr:arm-0.16.4sdk
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
