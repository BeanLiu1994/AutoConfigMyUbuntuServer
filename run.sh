#!/bin/sh -e
#run in su mode
cd ~

apt-get update & wait

apt-get install git -y & wait
git clone https://github.com/BeanLiu1994/AutoConfigMyUbuntuServer.git
cd AutoConfigMyUbuntuServer

chmod +x *.sh

. config.sh & wait