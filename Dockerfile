# === Build Stage ===
FROM ubuntu:22.04 AS builder

# 安装依赖
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        cmake \
        g++ \
        make \
        wget \
        libpthread-stubs0-dev \
        ca-certificates

# 安装 libcluon（可换源或自行编译）
RUN wget https://github.com/chrberger/libcluon/releases/download/v0.0.140/libcluon-dev_0.0.140_amd64.deb && \
    dpkg -i libcluon-dev_0.0.140_amd64.deb

# 拷贝源码并编译
WORKDIR /opt/sources
COPY . /opt/sources
RUN mkdir /opt/build && cd /opt/build && \
    cmake /opt/sources && \
    make && make test && cp helloworld /opt/helloworld

# === Deploy Stage ===
FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libstdc++6 && \
    apt-get clean

COPY --from=builder /opt/helloworld /usr/bin/helloworld

# 默认运行 helloworld
CMD ["/usr/bin/helloworld"]
