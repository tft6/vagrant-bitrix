#!/bin/bash

# Установка DNS гугла
sudo truncate -s 0 /etc/resolv.conf
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf
sudo echo "DNS1=8.8.8.8" >> /etc/sysconfig/network-scripts/ifcfg-eth0
sudo echo "DNS2=8.8.4.4" >> /etc/sysconfig/network-scripts/ifcfg-eth0

# Обновление системы
sudo yum update -y

# Установка mc
sudo yum install -y mc

# Установка окружения Битрикс
wget http://repos.1c-bitrix.ru/yum/bitrix-env.sh
chmod +x ./bitrix-env.sh
sudo ./bitrix-env.sh
sudo rm ./bitrix-env.sh

echo "bitrix" | passwd "bitrix" --stdin

sudo sed -i "s/~\/menu.sh/#~\/menu.sh/" /root/.bash_profile

# Доступ к БД с хост-машины
echo "create user 'root'@'192.168.33.1' identified by 'vagrant';" | mysql -u root
echo "grant all privileges on *.* to 'root'@'192.168.33.1' with grant option;" | mysql -u root

# Настройка модулей php
sudo mv /etc/php.d/30-mysqli.ini.disabled /etc/php.d/30-mysqli.ini
sudo mv /etc/php.d/20-curl.ini.disabled /etc/php.d/20-curl.ini

# Конфигурацмя xdebug
sudo rm /etc/php.d/15-xdebug.ini
sudo bash -c "echo 'zend_extension=/usr/lib64/php/modules/xdebug.so
xdebug.idekey = PHPSTORM
xdebug.remote_host=192.168.33.1
xdebug.remote_port=10000
xdebug.remote_enable=1
xdebug.remote_autostart=0
' >> /etc/php.d/15-xdebug.ini"

# Директория для сессий
sudo mkdir /tmp/php_sessions /tmp/php_sessions/www
sudo chown bitrix.bitrix /tmp/php_sessions/www

# Стартовать апач при загрузке
sudo service httpd restart
sudo chkconfig httpd on
