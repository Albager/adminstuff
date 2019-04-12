#!/bin/bash
echo
echo "This script will change the hostname in /etc/hostname and the \"FQDN\" in /etc/hosts files."

#Colors
txtrst=$(tput sgr0) # Text reset
txtbld=$(tput bold) # Bold text
txtylw=$(tput setaf 3) # Yellow
txtgrn=$(tput setaf 2) # Green

#Retrieve IPv4 assigned by static dhcp to $ip4
ip4=$(/sbin/ip -o -4 addr list enp0s25 | awk '{print $4}' | cut -d/ -f1)

#Retrieve hardware address to $mac
mac=$(ip link show enp0s25 | awk '/ether/ {print $2}')

#Retrieve FQDN from dns reverse lookup for current static-dhcp-assigned ip to $fqdn
fqdn=$(dig -x $ip4 +short | sed 's/.\{1\}$//')

#Assign existing (possibly wrong!) hostname to $hostn
hostn=$(cat /etc/hostname)

#Assign existing (possibly wrong!) fqdn to $oldfqdn
oldfqdn=$(grep -Po '(?<=127.0.1.1\s).*' /etc/hosts)

#Assign correct hostname from fqdn to $newhostn
newhostn=$(echo $fqdn | sed 's/\..*$//')

echo
#Display IPv4 address assigned by static dhcp
echo "The IPv4 address for your device \t${txtbld}$mac${txtrst} is ${txtbld}$ip4${txtrst}"

echo
#Display existing (possibly wrong!) FQDN
echo "Existing (possibly wrong!) FQDN is: \t${txtbld}$oldfqdn${txtrst}"
#Display correct FQDN (as retrieved from dns reverse lookup)
echo "Correct FQDN (from DNS) should be: \t${txtbld}${txtylw}$fqdn${txtrst}"

echo
#Display existing (possibly wrong!) hostname
echo "Existing (possibly wrong!) hostname is: ${txtbld}$hostn${txtrst}"
#Display correct hostname
echo "Correct hostname (from FQDN) should be: ${txtbld}${txtylw}$newhostn${txtrst}"

echo
while true; do
read -p "${txtbld}${txtylw}Change hostname and FQDN accordingly and reboot (y/n)?${txtrst} " choice
case "$choice" in 

y|Y )
echo "yes"

echo
#Change fqdn
sudo sed -i "s/$oldfqdn/$fqdn/g" /etc/hosts
#Check fqdn
fqdncheck=$(grep -Po '(?<=127.0.1.1\s).*' /etc/hosts)

#Change hostname
sudo sed -i "s/$hostn/$newhostn/g" /etc/hostname 

#Change hostname - for our purposes, hostname=fqdn!
#sudo sed -i "s/$hostn/$fqdn/g" /etc/hostname

#Check hostname
hostncheck=$(cat /etc/hostname)

#Display new hostname and FQDN
echo "Your new hostname is \t${txtbld}${txtgrn}$hostncheck${txtrst}"
echo "Your new FQDN is \t${txtbld}${txtgrn}$fqdncheck${txtrst}"
break
;;

n|N )
echo "no"
echo
while true; do
	read -p "${txtbld}${txtylw}Do you want to enter the correct settings and reboot (y/n)?${txtrst}  " choice1
	case "$choice1" in  	

	y|Y ) echo "yes"
	
	echo
  	#Ask to type new hostname
  	echo "Enter new hostname: "
  	read newhost
	#Change hostname
	sudo sed -i "s/$hostn/$newhost/g" /etc/hostname
	#Check hostname	
	hostncheck2=$(cat /etc/hostname)
	#Display new hostname
	echo "Your new hostname is now set to: \t${txtbld}${txtgrn}$hostncheck2${txtrst}"
	
	echo
	#Ask to type new FQDN
	echo "Enter new FQDN: "
	read newfqdn
	#Change FQDN
	sudo sed -i "s/$oldfqdn/$newfqdn/g" /etc/hosts
	#Check FQDN
	fqdncheck2=$(grep -Po '(?<=127.0.1.1\s).*' /etc/hosts)
	#Display new FQDN
	echo "Your new FQDN is now set to: \t\t${txtbld}${txtgrn}$fqdncheck2${txtrst}"
	break 2
	;;	

	n|N ) echo "no - quit"
	return
	;;
	
	*)
	echo "Invalid input... Type 'y' or 'n': "	
	;;
	
	esac
done

;;

*)
echo "Invalid input... Type 'y' or 'n': "
;;

esac
done

echo
echo "Rebooting now... Bye!"

sleep 1

#Reboot
sudo reboot