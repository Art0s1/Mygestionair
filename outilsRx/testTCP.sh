echo testTCP

echo ""
i=0
read -p " Entez the IP/URL you want to scan : " url
ip=$(ping -c 1 $url | grep -i PING | grep -Eo '\b((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\b' |sort -u)
echo $ip
echo ""
echo " Here are your options :  "
echo ""
echo " 1) - default (scans most used ports)"
echo " 2) - Basic (0 - 1000)"
echo " 3) - Advanced (0 - 5000)"
echo " 4) - All (0 - 65535)"
echo " y) - choose both starting point and end point of range"
read -p " Choose a mode of scan : " scanmode
echo ""
echo ""
 hping3func() {
	sudo hping3 -S -8 0-$portofend $ip | grep -i -E '\+.*|.*\.S..A...'
}
case $scanmode in
	1)
		ports=(1 7 9 13 17 19 20 21 22 23 25 37 53 67 68 69 80 81 88 110 123 135 137 138 139 143 161 162 381 389 443 464 465 587 593 694 829 959 989 990 995 1194 1337 1589 1725 1939 2082 2083 2222 2483 2484 3306 3389 5432 5900 5905 6379 6665 6666 6667 6668 6669 6881 6999  8000 8008 8080 8086 8087 8222 9100 8443 9000 9200 10000 12345 27017 27374 31337 49152)
		i=0
			max=${#ports[@]}
		echo "
Scanning $url ($ip), Default mode
$max ports to scan, use -V to see all the replies
+----+-----------+---------+---+-----+-----+-----+
|port| serv name |  flags  |ttl| id  | win | len |
+----+-----------+---------+---+-----+-----+-----+
"
		while [[ $i -lt $max ]] do
		sudo timeout 0.1 hping3 -S -8 "${ports[$i]}" "$ip" 2> /dev/null | grep -i -E '\+.*|.*\.S..A...'
			((i++))
		done
;;
	2)
		portofend=1000
		hping3func
	;;
	3)
		portofend=5000
		hping3func
	;;
	4)
		o=0
		i=1000
		max=66000
		echo "
Scanning $url ($ip), Default mode
$max ports to scan, use -V to see all the replies
+----+-----------+---------+---+-----+-----+-----+
|port| serv name |  flags  |ttl| id  | win | len |
+----+-----------+---------+---+-----+-----+-----+
"
		while [[ $i -lt $max ]] do
		echo "Scanning $o - $i ports"
		sudo hping3 -S -8 $o-$i $ip  2> /dev/null| grep -i -E '\+.*|.*\.S..A...' | sort -h -b
		((i = i + 1000))
		((o = o + 1000))
		done

	;;
	y)
	read -p " Please enter the Starting port : " startingport
	read -p " What will be your port of end ? : " endport
	sudo hping3 -S -8 $startingport-$endport $ip | grep -i -E '\+.*|.*\.S..A...'
	;;
	*)
		echo " Number unavailable "
	;;

esac
