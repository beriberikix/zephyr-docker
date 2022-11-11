FROM alpine:latest AS common

ARG ZEPHYR_VERSION=v3.2.0
ENV ZEPHYR_VERSION=${ZEPHYR_VERSION}

RUN \
  apk add --no-cache \
  build-base \
  git \
  linux-headers \
  python3 \
  python3-dev \
  py3-pip \
  py3-wheel \
  && pip3 install cmake \
  && pip3 install west \
  && pip3 install \
  -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/${ZEPHYR_VERSION}/scripts/requirements-base.txt

FROM common AS toolchain

ARG ARCHITECTURE=x86_64
ARG ZEPHYR_SDK_VERSION=0.15.1
ARG ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk
ARG TOOLCHAIN=arm-zephyr-eabi

RUN \
  export sdk_file_name="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-$(uname -m)_minimal.tar.gz" \
  && apk add --no-cache \
  bash \
  wget \
  && wget -q "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/${sdk_file_name}" \
  && mkdir -p ${ZEPHYR_SDK_INSTALL_DIR} && \
  tar -xvf ${sdk_file_name} -C ${ZEPHYR_SDK_INSTALL_DIR} --strip-components=1
# && ${ZEPHYR_SDK_INSTALL_DIR}/setup.sh -t ${TOOLCHAIN} \
# && rm ${sdk_file_name}