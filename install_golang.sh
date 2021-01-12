#!/bin/bash
GO_VERSION="1.14.2"

cd /tmp/ \
&& wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz \
&& sudo tar -C /usr/local -xzf go*.tar.gz \
&& sudo rm go$GO_VERSION*.gz

echo "Creating default Go folders"
mkdir -p $HOME/go/bin

if [[ -z "${GOROOT}" ]]; then
  echo "GOROOT is undefined --> creating defaut env variables"
  echo -e '\nexport PATH=$HOME/go/bin:$PATH
 export GOROOT=/usr/local/go
 export GOPATH=$HOME/go
 export GO111MODULE=on
 export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc;
  source $HOME/.bashrc
else
  echo "GOROOT env is alredy exists: $GOROOT"
fi

echo "Done"
