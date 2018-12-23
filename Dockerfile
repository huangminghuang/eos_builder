FROM ubuntu
RUN apt-get update \
    && apt-get install -y clang-4.0 lldb-4.0 libclang-4.0-dev cmake make automake libbz2-dev libssl-dev \
	     libgmp3-dev autotools-dev build-essential libicu-dev python2.7-dev python3-dev \
       autoconf libtool curl zlib1g-dev doxygen graphviz software-properties-common ninja-build ccache git \
    && add-apt-repository -y ppa:mhier/libboost-latest \
    && apt-get update \
    && apt-get install -y libboost1.67-dev
  
ARG LIBMONGOC_VERSION=1.10.2
ARG LIBMONGOCXX_VERSION=3.3.0
ARG CMAKE_OPTIONS="-H. -Bbuild -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local"

RUN mkdir mongo-c-driver && cd mongo-c-driver \
    && curl -L https://github.com/mongodb/mongo-c-driver/releases/download/$LIBMONGOC_VERSION/mongo-c-driver-$LIBMONGOC_VERSION.tar.gz | tar --strip-components=1 -xz \
    && cmake $CMAKE_OPTIONS -DENABLE_BSON=ON -DENABLE_SSL=OPENSSL -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DENABLE_STATIC=ON \
    && cmake --build build --target install \
    && cd .. && rm -rf mongo-c-driver

RUN mkdir mongo-cxx-driver && cd mongo-cxx-driver \
    && curl -L https://github.com/mongodb/mongo-cxx-driver/archive/r${LIBMONGOCXX_VERSION}.tar.gz | tar --strip-components=1 -xz \
    && cmake $CMAKE_OPTIONS \
    && cmake --build build --target install \
    && cd .. && rm -rf mongo-cxx-driver

RUN git clone --depth 1 --single-branch --branch release_40 https://github.com/llvm-mirror/llvm.git \
    && git clone --depth 1 --single-branch --branch release_40 https://github.com/llvm-mirror/clang.git llvm/tools/clang \
    && cd llvm \
    && cmake -H. -Bbuild -GNinja -DCMAKE_INSTALL_PREFIX=/opt/wasm -DLLVM_TARGETS_TO_BUILD= -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly -DCMAKE_BUILD_TYPE=Release  \
    && cmake --build build --target install \
    && cd .. && rm -rf llvm