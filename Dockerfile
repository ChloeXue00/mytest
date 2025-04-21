# === Build Stage ===
FROM ubuntu:22.04 AS builder

# install basic tools and Cluon PPA
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:chrberger/libcluon && \
    apt-get update && \
    apt-get install -y \
        git \
        cmake \
        g++ \
        make \
        libcluon \
        ca-certificates

# copy mytest code
WORKDIR /opt/mytest
COPY . /opt/mytest

# build helloworld
RUN rm -rf build && mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && \
    # make tests && \
    cp helloworld /usr/bin/helloworld

# === Deploy Stage ===
FROM ubuntu:22.04

# install running dependencies , libstdc++6 necessary
RUN apt-get update && apt-get install -y libstdc++6 && apt-get clean

# copy compiled prog
COPY --from=builder /usr/bin/helloworld /usr/bin/helloworld

# start the executable prog when start
CMD ["/usr/bin/helloworld"]
