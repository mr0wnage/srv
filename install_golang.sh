wget https://golang.org/dl/go1.15.8.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.8.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc
echo 'export GOPATH=/usr/local/go' >> $HOME/.bashrc
source ~/.bashrc
go version




#!/bin/bash
GO_VERSION=${GO_VERSION:=1.15.2}

cd /tmp/ \
&& wget -q https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz \
&& rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go*.tar.gz \
&& rm go$GO_VERSION*.gz

echo "Creating default Go folders"
mkdir -p $HOME/go/bin

if [[ -z "${GOROOT}" ]]; then
  echo "GOROOT is undefined --> creating defaut env variables"
  echo -e '\nexport PATH=$HOME/go/bin:$PATH
 export GOROOT=/usr/local/go
 export GOPATH=$HOME/go
 export GO111MODULE=auto
 export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc;
  source $HOME/.bashrc
else
  echo "GOROOT env is alredy exists: $GOROOT"
fi

echo "Done"
