#!/bin/sh -e
pathhere=pwd
cd ~
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]start autoconfig sequence" > AutoConfigLog
#0. somethings iwanna install
apt-get install build-essential autoconf libtool libssl-dev gcc zsh -y & wait
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

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

#3. extra
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]3.start" >> AutoConfigLog
apt-get install octave mysql-server -y & wait
mysqladmin -u root password 123456
cd ~
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]3.end" >> AutoConfigLog

#all done
echo "[config.sh `date '+%Y-%m-%d %H:%M:%S'`]all done" >> AutoConfigLog

rm -rf AutoConfigMyUbuntuServer