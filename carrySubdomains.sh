#!/bin/bash
echo "############## script started ###############"
echo " "
echo "[+] Getting All Subdomains....."

if [ $# != 1 ]
then
		echo "Usage: $0 <domain> "
else
wget $1 2>/dev/null && cat index.html | grep 'http' | cut -d ':' -f2 | cut -d '/' -f3 | cut -d '"' -f1 | grep $1 >  subdomains.txt
cat subdomains.txt
fi


echo " " 
echo "[+] Getting Only Valid Subdomains......."
echo " "

for sub in $(cat subdomains.txt)
do
if [[ $(ping -c 1 $sub 2>/dev/null) ]]
then
		echo "$sub +++++++ pong"
		echo $sub >> valid_sub.txt
else
		echo "$sub ------- error"
		echo $sub >> unvalid_sub.txt
fi
done


echo " "
echo "[+] Getting IP of the valid hosts" 
echo " "

for ip in $(cat valid_sub.txt)
do
host $ip
host $ip | cut -d " " -f4 | head -1 | uniq >> ips.txt
done

echo " "
echo "############ script finished ################
