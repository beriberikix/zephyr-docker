FROM debian:stable-slim AS base

RUN \
  apt-get -y update \
  && apt-get -y install --no-install-recommends \
  cmake \
  device-tree-compiler \
  git \
  ninja-build \
  python3 \
  python3-pip \
  wget \
  xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM base AS sdk

ARG ZEPHYR_SDK_VERSION=0.16.1
ARG ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk
ARG ZEPHYR_SDK_TOOLCHAIN="-t arm-zephyr-eabi"
ENV ZEPHYR_SDK_TOOLCHAIN=${ZEPHYR_SDK_TOOLCHAIN}

RUN \
  export sdk_file_name="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-$(uname -m)_minimal.tar.xz" \
  && apt-get -y update \
  && apt-get -y install --no-install-recommends \
  wget \
  xz-utils \
  && wget -q "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/${sdk_file_name}" \
  && mkdir -p ${ZEPHYR_SDK_INSTALL_DIR} \
  && tar -xvf ${sdk_file_name} -C ${ZEPHYR_SDK_INSTALL_DIR} --strip-components=1 \
  && ${ZEPHYR_SDK_INSTALL_DIR}/setup.sh ${ZEPHYR_SDK_TOOLCHAIN} \
  && rm ${sdk_file_name} \
  && apt-get remove -y --purge \
  wget \
  xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM sdk AS west

RUN \
  apt-get -y update \
  && apt-get -y install --no-install-recommends \
  python3 \
  python3-pip \
  && pip3 install --break-system-packages --no-cache-dir wheel west \
  && apt-get remove -y --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM west AS python

ARG ZEPHYR_VERSION=v3.4.0
ENV ZEPHYR_VERSION=${ZEPHYR_VERSION}

RUN \
  apt-get -y update \
  && apt-get -y install --no-install-recommends \
  python3 \
  python3-pip \
  && pip3 install --break-system-packages --no-cache-dir wheel \
  && pip3 install --break-system-packages --no-cache-dir \
  -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/${ZEPHYR_VERSION}/scripts/requirements-base.txt \
  && apt-get remove -y --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*