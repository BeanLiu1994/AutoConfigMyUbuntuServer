#!/bin/sh -e
pathhere=~/AutoConfigMyUbuntuServer
cd ~
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]start autoconfig sequence" > AutoConfigLog
#0. somethings iwanna install
apt-get install build-essential autoconf libtool libssl-dev gcc zsh octave -y
wait
cd ~
#1. shadowsocks
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]1.start" >> AutoConfigLog
cd $pathhere
. ./ss.sh
cd ~
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]1.end" >> AutoConfigLog

#2. apache2
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]2.start" >> AutoConfigLog
cd $pathhere
. ./ap2.sh
cd ~
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]2.end" >> AutoConfigLog

#3. extra  #things need a human to finish
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]3.start" >> AutoConfigLog

#sql
apt-get install mysql-server -y 
#input a root password manully.
wait

#zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
#exit from zsh manully.
wait

cd ~
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]3.end" >> AutoConfigLog

#all done
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]all done" >> AutoConfigLog
