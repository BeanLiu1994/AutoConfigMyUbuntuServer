#!/bin/sh -e
#run in su mode
cd ~

rm -rf AutoConfigMyUbuntuServer

apt-get update && apt-get install git -y && git clone https://github.com/BeanLiu1994/AutoConfigMyUbuntuServer.git

cd AutoConfigMyUbuntuServer

chmod +x *.sh

. ./config.sh & wait