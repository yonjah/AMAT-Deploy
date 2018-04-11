# Feed Thug with a txt file save localy on disk/http server
# Optional just to gather more samples

#!/bin/bash

cd /opt/thug/

#Download the URLlist from local http
sudo wget http://IP/file.txt            #local HTTP server if present

# Run python scritp to compare if there are updates in the latest URL list, not needed if the file is static from local http and not public
#sudo python compare.py

file="file.txt"

while IFS= read line

do
        printf "URL being scanned: $line"
        printf "\n==================================================================\n"
        sudo thug -F -n /opt/thug/logs/ $line
        sed -i '1,1 d' file.txt
	sleep 60

done <"$file"

# sudo mv file.txt oldfile.txt
