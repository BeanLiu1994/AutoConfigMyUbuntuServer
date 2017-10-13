#!/bin/sh -e

#shadowsocks
#you can use "-p password" to set a password
#use "-s" to use default password

cd ~

apt-get update
wait
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]start" >> AutoConfigLog 
apt-get install qrencode apache2 git jq -y
wait
rm -rf ~/shadowsocksr
git clone https://github.com/shadowsocksr-rm/shadowsocksr.git


wait
echo "[ssr.sh `date '+%Y-%m-%d %H:%M:%S'`]ssr cloned" >> AutoConfigLog 

if [ "$mypassword" = "" ];then
        mypassword="mypassword"
fi
if [ "$myport" = "" ];then
        myport="1580"
fi

silent="False"
while getopts "p:n:s" ARGS
do
        case $ARGS in
             p)
                mypassword="$OPTARG";; 
             n)
                myport="$OPTARG";; 
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

cd ~/shadowsocksr
bash initcfg.sh
method="aes-256-cfb"
obfs="tls1.2_ticket_auth"
obfsparam="hello"
sed 's/0.0.0.0/::/g' -i user-config.json
sed "s/8388/$myport/g" -i user-config.json
sed "s/8388/$myport/g" -i user-config.json
sed "s/password.*/password\": \"$mypassword\",/g" -i user-config.json
sed "s/method.*/method\": \"$method\",/g" -i user-config.json
sed "s/obfs\".*/obfs\": \"$obfs\",/g" -i user-config.json
sed "s/obfs_param\".*/obfs_param\": \"$obfsparam\",/g" -i user-config.json
./shadowsocks/logrun.sh


protocol=`cat user-config.json | sed '/additional_ports/d' |jq .protocol|sed 's/\"//g'`

ip=$(ifconfig eth0 |awk -F '[ :]+' 'NR==2 {print $4}')
passbase64=$(echo -n "$mypassword" | base64 -w 0)
passbase64=`echo $passbase64|sed 's/=//g'`
passbase64=`echo $passbase64|sed 's/+/-/g'`
passbase64=`echo $passbase64|sed 's/\//_/g'`
obfsparambase64=$(echo -n "$obfsparam" | base64 -w 0)
obfsparambase64=`echo $obfsparambase64|sed 's/=//g'`
obfsparambase64=`echo $obfsparambase64|sed 's/+/-/g'`
obfsparambase64=`echo $obfsparambase64|sed 's/\//_/g'`
additional_message="obfsparam=$obfsparambase64&group=QkxTU1JNSU5F"
qr_url=$(echo -n "$ip:$myport:$protocol:$method:$obfs:$passbase64/?$(echo $additional_message|iconv -f gbk -t UTF-8)"|base64 -w 0)
qr_url=`echo $qr_url|sed 's/+/-/g'`
qr_url=`echo $qr_url|sed 's/\//_/g'`
qr_url="ssr://"$qr_url
echo $qr_url
qrencode -o qrcode.png "$qr_url"
echo "$qr_url" > qrcode.qrcontent 
cp qrcode.png /var/www/html/ 
echo "see config qr at http://$ip/qrcode.png"
cd ~

echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]config saved. finished" >> AutoConfigLog 