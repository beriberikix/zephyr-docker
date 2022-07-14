FROM ubuntu:focal-20220531 AS common

CMD ["/bin/bash"]

ENV DEBIAN_FRONTEND=noninteractive

ARG ZEPHYR_VERSION=v3.0.0
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

#------------------------------------------------------------------------------

FROM common AS dev-generic

ENV LC_ALL=C
ENV PAGER=less

RUN \
  apt-get -y update \
  && apt-get -y install --no-install-recommends \
  curl \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get -y update \
  && apt-get -y install --no-install-recommends \
  clang-format \
  gdb \
  gpg \
  gpg-agent \
  less \
  libpython3.8-dev \
  libsdl2-dev \
  locales \
  nano \
  nodejs \
  python3 \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-tk \
  python3-wheel \
  socat \
  ssh \
  tio \
  wget \
  xz-utils \
  && pip3 install \
  -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/${ZEPHYR_VERSION}/scripts/requirements-build-test.txt \
  -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/${ZEPHYR_VERSION}/scripts/requirements-run-test.txt \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# what does this do?
ARG ZEPHYR_SDK_VERSION
ENV ZEPHYR_SDK_VERSION=${ZEPHYR_SDK_VERSION}

ENV DEBIAN_FRONTEND=

#------------------------------------------------------------------------------

FROM common AS build

ARG ARCHITECTURE=x86_64
ARG ZEPHYR_SDK_VERSION=0.14.2
ARG ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk-${ZEPHYR_SDK_VERSION}
ARG TOOLCHAIN=arm-zephyr-eabi
RUN \
  export sdk_file_name="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-$(uname -m)_minimal.tar.gz" \
  && apt-get -y update \
  && apt-get -y install --no-install-recommends \
  wget \
  xz-utils \
  && wget -q "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/${sdk_file_name}" \
  && mkdir -p ${ZEPHYR_SDK_INSTALL_DIR} && \
  tar -xvf ${sdk_file_name} -C ${ZEPHYR_SDK_INSTALL_DIR} --strip-components=1 \
  && ${ZEPHYR_SDK_INSTALL_DIR}/setup.sh -t ${TOOLCHAIN} \
  && rm ${sdk_file_name} \
  && apt-get remove -y --purge \
  wget \
  xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

#------------------------------------------------------------------------------

FROM dev-generic AS dev

ARG ZEPHYR_SDK_VERSION=0.14.2
ARG ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk-${ZEPHYR_SDK_VERSION}

COPY --from=build ${ZEPHYR_SDK_INSTALL_DIR} ${ZEPHYR_SDK_INSTALL_DIR}

RUN /opt/zephyr-sdk-${ZEPHYR_SDK_VERSION}/setup.sh -c