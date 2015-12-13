#!/bin/sh -e
#run in su mode
apt-get update

apt-get install git -y
git clone https://github.com/BeanLiu1994/AutoConfigMyUbuntuServer.git
cd AutoConfigMyUbuntuServer

source config.sh