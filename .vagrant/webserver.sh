#!/bin/bash

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
