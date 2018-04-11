#!/bin/bash

cd /opt/thug/

#
URL to connect to and download the URL list
sudo wget https://ransomwaretracker.abuse.ch/downloads/RW_URLBL.txt -O file.txt

sudo sed -i '1,7d' file.txt
sudo sed -i '$d' file.txt

if [[ ! -e oldfile.txt ]]; then
        touch oldfile.txt
fi

# Run python scritp to compare if there are updates in the latest URL list
sudo python compare.py

file="urls.txt"

while IFS= read line

do
        printf "URL being scanned: $line"
        printf "\n==================================================================\n"
        sudo thug -F -n /opt/thug/logs/ $line
        sed -i '1,1 d' urls.txt
	sleep 60

done <"$file"

sudo mv file.txt oldfile.txt
