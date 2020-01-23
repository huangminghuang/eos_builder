FROM ubuntu:18.04
ARG BOOST_VERSION_MAJOR=1
ARG BOOST_VERSION_MINOR=71
ARG BOOST_VERSION_PATCH=0
RUN apt-get -y update && apt-get install -y build-essential git llvm-4.0-dev clang-8 \
    curl make automake apt-transport-https ca-certificates gnupg\
    libtool software-properties-common ninja-build python-pip python-setuptools wget \
    libbz2-dev libssl-dev zlib1g-dev libgmp3-dev libicu-dev libusb-1.0-0-dev libcurl4-gnutls-dev pkg-config && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - \
    && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && apt-get update \
    && apt-get -y install cmake && rm -rf /var/lib/apt/lists/*
ENV BOOST_VERSION ${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}.${BOOST_VERSION_PATCH}
ENV BOOST_ID boost_${BOOST_VERSION_MAJOR}_${BOOST_VERSION_MINOR}_${BOOST_VERSION_PATCH}
RUN curl -LO https://dl.bintray.com/boostorg/release/$BOOST_VERSION/source/$BOOST_ID.tar.bz2 && \
    tar -xjf $BOOST_ID.tar.bz2 && \
    cd $BOOST_ID && \
    ./bootstrap.sh --prefix=/usr/local && \
    ./b2 link=static threading=multi --with-iostreams --with-date_time --with-filesystem --with-system --with-program_options --with-chrono --with-test -q -j$(nproc) install && \
    cd .. && rm -rf $BOOST_ID && rm $BOOST_ID.tar.bz2
    
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 100 \
  && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-8 100

# Set enviroment variables
ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++
ENV CMAKE_PREFIX_PATH=/usr/lib/llvm-8