#!/bin/sh -e

#shadowsocks
cd ~
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]start" >> AutoConfigLog
apt-get install python-pip -y
wait
pip install shadowsocks
wait
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]python installed" >> AutoConfigLog
mkdir ~/ShadowSocksConfig
cd ~/ShadowSocksConfig
echo "{" > config.json
echo "	\"server\":\"::\"," >> config.json
echo "	\"server_port\":\"8388\"," >> config.json
echo "	\"local_port\":1080," >> config.json
echo "	\"password\":\"mypassword\"," >> config.json
echo "	\"timeout\":300," >> config.json
echo "	\"method\":\"aes-256-cfb\"," >> config.json
echo "	\"fast_open\":false" >> config.json
echo "}" >> config.json

echo "	nohup ssserver -c config.json > ssslog &" > runsss.sh
chmod +x runsss.sh

cd ~
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]config saved. finished" >> AutoConfigLog