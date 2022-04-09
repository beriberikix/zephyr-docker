FROM ubuntu:jammy-20220404 AS common

CMD ["/bin/bash"]

ENV DEBIAN_FRONTEND=noninteractive

ARG ZEPHYR_VERSION=main
ENV ZEPHYR_VERSION=${ZEPHYR_VERSION}

RUN \
  apt-get -y update \
  && if [ "$(uname -m)" = "x86_64" ]; then gcc_multilib="gcc-multilib"; else gcc_multilib=""; fi \
  && apt-get -y install --no-install-recommends \
  ccache \
  file \
  gcc \
  "${gcc_multilib}" \
  git \
  gperf \
  make \
  ninja-build \
  python3 \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-wheel \
  && pip3 install \
  -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/${ZEPHYR_VERSION}/scripts/requirements-base.txt \
  && pip3 install cmake \
  && apt-get remove -y --purge \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-wheel \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*