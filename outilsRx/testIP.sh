echo testIP

Red='\033[0;31m'
Yellow='\033[0;33m'
Green='\033[0;32m'
coff='\033[0m'

try="y"
while [[ "$try" != "n" ]]; do
	echo ""
	read -p "Please Select The IP You Want To Check : " ip
	if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo ""
		result=$(ping -c 5 $ip |grep "received" |cut -d " " -f 4)
		if [[ $result -eq 5 ]]; then
			echo -e "${Green} The Ip $ip Has Received $result/5 Packets ${coff}"
		elif [[ $result -gt 2 && $result -lt 5 ]]; then
			echo -e "${Yellow} The Ip $ip Has Received $result/5 Packets ${coff}"
		else
			echo -e "${Red} The Ip $ip Has Received $result/5 Packets ${coff}"
		fi
	fi
	echo ""
	read -p "Retry ? (y/n) : " try
done
