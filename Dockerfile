FROM ubuntu:20.04

ENV TZ="UTC"
ENV USER_NAME=koii \
    UID=10001 \
    GID=10001

RUN \
  apt update && apt install -y curl tzdata \
    && ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt install -y libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang \
    && groupadd -g $GID -o $USER_NAME \
    && useradd -m -u $UID -g $GID -o -s /bin/bash $USER_NAME

ENV KOII_RELEASE=v0.0.1 \
    KOII_INSTALL_INIT_ARGS=v0.0.1 \
    KOII_DOWNLOAD_ROOT="https://github.com/koii-network/k2-release/releases/download" \
    TARGET=x86_64-unknown-linux-gnu

RUN \
  curl -L "$KOII_DOWNLOAD_ROOT/${KOII_RELEASE}/koii-install-init-$TARGET" -o /usr/bin/koii-install-init \
  && chmod +x /usr/bin/koii-install-init

USER koii

RUN \
    /usr/bin/koii-install-init $KOII_INSTALL_INIT_ARGS

