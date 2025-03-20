#!/bin/bash

User=$(whoami)
if [[ $User != 'root' ]]; then
    echo "Connectez vous en root pour continuer l'installation"
    exit 0
fi

read -p "utilisez vous un serveur(1) ou client(0) ? : " Serv

while [ $Serv -ne 0 -a $Serv -ne 1 ]; do
    echo "Veuillez saisir 0 pour une installation serveur, 1 pour installation client"
    read -p "L'outil est-il sur une machine serveur ou cliente ? (0 pour client, 1 pour serveur)" Serv
done

case $Serv in
0)
    echo serveur=0 > ../config.sh
    install=0
;;
1)
    echo serveur=1 > ../config.sh
    install=1
;;
esac

apt update && apt install -y mariadb-server figlet netcat-openbsd sudo

if [[ $install -eq 0 ]]; then
    apt install -y lolcat
fi

mysql -e "
CREATE DATABASE MyGest; 
CREATE USER 'GestAdmin'@'localhost';
GRANT ALL PRIVILEGES ON MyGest.* TO 'GestAdmin'@'localhost';
FLUSH PRIVILEGES;"

mysql -u GestAdmin MyGest < myGestIOnR.sql
