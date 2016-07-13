#!/bin/sh -e

#shadowsocks
#you can use "-p password" to set a password
#use "-s" to use default password

cd ~
# apt-get update
# wait
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]start" >> AutoConfigLog 
apt-get install python-pip qrencode apache2 -y
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
                echo "unknow argument";;
        esac
done

if [ "$mypassword" = "mypassword" ];then
        if [ x"$silent" = x"False" ];then
                echo "please set your password:"
                read mypassword
        fi
fi

encrypt="aes-256-cfb"
port="8388"

echo "{" > config.json 
echo "	\"server\":\"::\"," >> config.json 
echo "	\"server_port\":\"$port\"," >> config.json 
echo "	\"local_port\":1080," >> config.json 
echo "	\"password\":\"$mypassword\"," >> config.json 
echo "	\"timeout\":300," >> config.json 
echo "	\"method\":\"$encrypt\"," >> config.json 
echo "	\"fast_open\":false" >> config.json 
echo "}" >> config.json

echo "	nohup ssserver -c config.json > ssslog &" > runsss.sh 
chmod +x runsss.sh

if [ ! "$mypassword" = "mypassword" ];then 
        eval $(cat runsss.sh)
        ip=$(ifconfig eth0 |awk -F '[ :]+' 'NR==2 {print $4}')
        qr_url="ss://"$(echo -n "$encrypt:$mypassword@$ip:$port" | base64)
        qrencode -o qrcode.png "$qr_url"
        echo "$qr_url" > qrcode.qrcontent 
        cp qrcode.png /var/www/html/ 
        echo "see config qr at http://$ip/qrcode.png"
fi

cd ~
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]config saved. finished" >> AutoConfigLog 