echo checkValid

Red='\033[0;31m'
Yellow='\033[0;33m'
Green='\033[0;32m'
coff='\033[0m'

echo ""
echo " 1) - Scan Network From Nothing"
echo " 2) - Scan Network Via Database"
read -p "You Choose : " selectscan
echo ""
case $selectscan in
1)
	echo "Here is Your Ip :"
	echo ""
	hostname -I
	echo ""
	read -p "Please Enter The Three first Bytes Of The Scan Network : " network
	read -p "Please Enter The CIDR : " cidr
	if [[ $network =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && [[ $cidr -ge 0 && $cidr -le 30 ]]
	then
		if [[ -f "Results_ip.txt" ]]
		then
			rm Results_ip.txt
		fi
		i=0
		datee=$(date)
		echo -e "This Will Take A While. No Worries, All ${Green}Active${coff} Ip(s) Will Be Written In Results_ip.txt . I Suggest You Take A Coffee Break ! :)"
		sleep 2
		echo "" >> Results_ip.txt
		echo "Ip Tests Of $network.0 From : $datee" >> Results_ip.txt
		echo "" >> Results_ip.txt
		while [[ $i -lt 254 ]]
		do
			((i++))
			if ping -c 1 -W 0.3 "$network.$i" &> /dev/null
			then
				echo -e "$network.$i : ${Green}Active${coff}"
				echo -e "$network.$i : ${Green}Active${coff}" >> Results_ip.txt

			else
				echo -e "$network.$i : ${Red}Inactive${coff}"
			fi
		done
	echo ""
	echo "Here Are All Of Active Ips On The Network $network.0"
	cat Results_ip.txt
#	echo ""
#	read -p " Would You Like To Compare The Results From File, Database Or Not ? (f,d,n) : " comparison
#	case $comparison in
#	f)
#		read -p "Please Select the File : " file
#	;;
#	d)
#		read -p "Please Select the Database : " file
#	;;
#	n)
#		echo "Bye :)" |figlet |lolcat
#	;;
#	esac
	else
		echo "Network Invalid"
	fi
;;
2)
rm ipcheck.txt
echo ""
mysql -u root -p'btsinfo' -e "show databases;"
echo ""
read -p "Please Enter The Dbname : " dbname
mysql -u root -p'btsinfo' -e "show tables from $dbname"
read -p "Please Select The Table : " dbtable
mysql -u root -p'btsinfo' -e "select * from $dbname.$dbtable"
echo ""
read -p "Please Select a Column : " dbcolumn
mysql -u root -p'btsinfo' $dbname -e "select $dbcolumn from $dbtable" -N > ipcheck.txt
sleep 2
echo ""
echo "Scanning, Please Wait."
echo ""
cat ipcheck.txt | while read ip
do
	if ping -c 1 -W 1 $ip &> /dev/null
	then
		echo -e "$ip : ${Green}Active${coff}"
	else
		echo -e "$ip : ${Red}Inactive${coff}"
	fi
done
;;
esac
