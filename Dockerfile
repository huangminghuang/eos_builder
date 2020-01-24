FROM ubuntu:18.04
ARG BOOST_VERSION_MAJOR=1
ARG BOOST_VERSION_MINOR=71
ARG BOOST_VERSION_PATCH=0
RUN apt-get -y update && apt-get install -y --no-install-recommends git llvm-4.0-dev llvm-8-dev clang-8 \
    curl make automake apt-transport-https ca-certificates gnupg\
    libtool software-properties-common ninja-build python \
    libbz2-dev libssl-dev zlib1g-dev libgmp3-dev libicu-dev libusb-1.0-0-dev libcurl4-gnutls-dev pkg-config && \
    curl https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - \
    && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && apt-get update \
    && apt-get -y install --no-install-recommends cmake && \
    rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 100 \
  && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-8 100 \
  && update-alternatives --install /usr/bin/cc cc /usr/bin/clang-8 100 \
  && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-8 100

ENV BOOST_VERSION ${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}.${BOOST_VERSION_PATCH}
ENV BOOST_ID boost_${BOOST_VERSION_MAJOR}_${BOOST_VERSION_MINOR}_${BOOST_VERSION_PATCH}
RUN curl -L https://dl.bintray.com/boostorg/release/$BOOST_VERSION/source/$BOOST_ID.tar.bz2 | tar -xj  && \
    cd $BOOST_ID && \
    ./bootstrap.sh --prefix=/usr/local && \
    ./b2 link=static threading=multi --with-iostreams --with-date_time --with-filesystem --with-system --with-program_options --with-chrono --with-test -q -j$(nproc) install && \
    cd .. && rm -rf $BOOST_ID
    
# Set enviroment variables
ENV CMAKE_PREFIX_PATH=/usr/lib/llvm-8