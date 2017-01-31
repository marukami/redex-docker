FROM ubuntu:16.04

# Install java8
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes \
    expect \
    git \
    wget \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    python \
    curl \
    libqt5widgets5 \
    python3 \
    g++ \
    automake \
    autoconf \
    autoconf-archive \
    libtool \
    libboost-all-dev \
    liblz4-dev \
    liblzma-dev \
    make \
    zlib1g-dev \
    binutils-dev \
    libjemalloc-dev \
    libiberty-dev \
    libjsoncpp-dev && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Install Android SDK
RUN cd /opt && wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
  tar xzf android-sdk.tgz && \
  rm -f android-sdk.tgz && \
  chown -R root.root android-sdk-linux && \
  /opt/tools/android-accept-licenses.sh "android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools,build-tools-25.0.2,android-25"

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV PATH ${PATH}:${ANDROID_HOME}/build-tools/25.0.2

RUN which adb
RUN which android
RUN which zipalign

RUN git clone --depth 1 https://github.com/facebook/redex.git 

RUN cd redex && \
    autoreconf -ivf && \
    ./configure && \
    make && \
    make install

# Cleaning
RUN apt-get clean

WORKDIR /redex

ENTRYPOINT ["redex"]
