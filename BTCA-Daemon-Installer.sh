#!/bin/bash

# Functions
add_ppa(){
  grep -h "bitcoin" /etc/apt/sources.list.d/* > /dev/null
  if [ $? -ne 0 ]
  then
    echo "Adding Bitcoin PPA."
    yes "" | add-apt-repository ppa:bitcoin/bitcoin
  else
    echo "Bitcoin PPA already exists!"
  fi
}

# Entrypoint
cd ..

# Add Bitcoin PPA
add_ppa && apt-get update

# Install Dependancies
apt-get -qq install zip \
        curl \
        build-essential \
        libtool \
        autotools-dev \
        autoconf \
        automake \
        pkg-config \
        libssl-dev \
        libevent-dev \
        bsdmainutils \
        git \
        cmake \
        libboost-all-dev \
        software-properties-common \
        libdb4.8-dev libdb4.8++-dev \
        libminiupnpc-dev \
        libzmq3-dev \
        libgmp3-dev \
        libsodium-dev \
        cargo

# Clone the Bitcoin Anonymous Node repository and compile
git clone https://github.com/Bitcoin-Anonymous/BTCA-Node.git
cd BTCA-Node
./autogen.sh
./configure --without-gui
make -j$(nproc)
echo "Build complete. Installing app and privacy params."
make install
./util/fetch-params.sh
echo "Install complete!"

chown -R $(logname): ../BTCA-Node

echo
echo -e "\e[1m\e[92mSetup complete! Now run btcad --daemon\e[0m"
echo