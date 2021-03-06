#!/bin/sh -e


#shadowsocks
cd ~
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]start" >> AutoConfigLog
apt-get install apache2 -y
wait
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]apache2 installed" >> AutoConfigLog
mkdir -p /var/www/LpServer/public_html
chmod -R 775 /var/www

cd /var/www/LpServer/public_html

echo "<!DOCTYPE html>" > index.html
echo "<html>" >> index.html
echo "<head>" >> index.html
echo "<title>TestPage</title>" >> index.html
echo "</head>" >> index.html
echo "<body>" >> index.html
echo "<meta charset=\"UTF-8\">" >> index.html
echo "<h1>Testing 测试 テスト 테스트  испытания </h1>" >> index.html
echo "</body>" >> index.html
echo "</html>" >> index.html

#there should be a new config file for apache in /etc/apache2/sites-available/...

a2dissite default
a2ensite NewConf
service apache2 restart

cd ~
echo "[ss.sh `date '+%Y-%m-%d %H:%M:%S'`]config saved. finished" >> AutoConfigLog