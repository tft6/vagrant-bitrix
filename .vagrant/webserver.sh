#!/bin/bash

sudo yum install update -y

# Установка mc
sudo yum install -y mc

# Правила для iptables
sudo echo '# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m tcp --dport 8894 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 8893 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 8891 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 8890 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 5223 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 5222 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT' >> /etc/sysconfig/iptables

#Рестарт iptables
service iptables restart

#Установка окружения Битрикс
wget http://repos.1c-bitrix.ru/yum/bitrix-env.sh
chmod +x ./bitrix-env.sh
sudo ./bitrix-env.sh
sudo rm ./bitrix-env.sh

echo "bitrix" | passwd "bitrix" --stdin

sudo sed -i "s/~\/menu.sh/#~\/menu.sh/" /root/.bash_profile
