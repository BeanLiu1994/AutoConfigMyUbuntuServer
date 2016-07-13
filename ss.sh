#!/bin/sh -e

#shadowsocks
#you can use "-p password" to set a password
#use "-s" to use default password

cd ~
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]start" >> AutoConfigLog
apt-get install python-pip -y
wait
pip install shadowsocks
wait
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]python installed" >> AutoConfigLog
mkdir ~/ShadowSocksConfig
cd ~/ShadowSocksConfig

if [ "$mypassword" = "" ];then
        mypassword="mypassword"
fi

silent="False"
while getopts "p:s" ARGS
do
        case $ARGS in
             p)
                mypassword="$OPTARG";; 
             s)
                silent="True";;
             *) 
                echo "unkonw argument";;
        esac
done

if [ "$mypassword" = "mypassword" ];then
        if [ x"$silent" = x"False" ];then
                echo "please set your password:"
                read mypassword
        fi
fi

echo "{" > config.json
echo "	\"server\":\"::\"," >> config.json
echo "	\"server_port\":\"8388\"," >> config.json
echo "	\"local_port\":1080," >> config.json
echo "	\"password\":\"$mypassword\"," >> config.json
echo "	\"timeout\":300," >> config.json
echo "	\"method\":\"aes-256-cfb\"," >> config.json
echo "	\"fast_open\":false" >> config.json
echo "}" >> config.json

echo "	nohup ssserver -c config.json > ssslog &" > runsss.sh
chmod +x runsss.sh

cd ~
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]config saved. finished" >> AutoConfigLog