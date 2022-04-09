# Zephyr Docker
Optimized Docker images, originally based on [zmk-docker](https://github.com/zmkfirmware/zmk-docker).

Note 1. Currently only supports local development. CI integration planned for the future.

Note 2. Supports Zephyr SDK 0.14.1 and later.

# Important build arguments

* ARCHITECTURE - Architecture for the docker cotnainer. Not to be confused with target architecture.
* ZEPHYR_SDK_VERSION - SDK version. Must be 0.14.1-rc2 or later.
* ZEPHYR_VERSION - Zephyr version. Can be a tag or branch, including `main`
* TOOLCHAIN - target toolchain.

# Building with Docker CLI

_To build an image for main that supports v3.0.0 and Arm Cortex-M targets:_

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.14.1-rc2 --build-arg ZEPHYR_VERSION=v3.0.0 --build-arg TOOLCHAIN=arm-zephyr-eabi -t zephyr:v3.0.0-arm .
```

_To build an image for main that supports every target:_

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.14.1-rc2 --build-arg ZEPHYR_VERSION=main --build-arg TOOLCHAIN=all -t zephyr:x86_64_0.14.1-rc2_main_all .
```

This follows a tagging convention of ARCHITECTURE_ZEPHYR_SDK_VERSION_ZEPHYR_VERSION_TOOLCHAIN. It will be a _large_ image since it pulls in every toolchain (~6GB.)