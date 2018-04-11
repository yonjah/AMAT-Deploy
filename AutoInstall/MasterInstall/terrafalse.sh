#!/bin/bash

./packer build -var-file variables.json MispVM.json
./packer build -var-file variables.json FameVM.json
./packer build -var-file variables.json CuckooVM.json
./packer build -var-file variables.json DionaeaVM.json
./packer build -var-file variables.json ViperVM.json
./packer build -var-file variables.json MastiffVM.json

#Turns on machine in order (need to alter autovm script to include all vms once all done)
sshpass -p "##EnterPassword##" scp ./autovm_poweron.sh ##ESXi Root##@##ESXi IP##:/
echo -e "./autovm_poweron.sh" | sshpass -p "##EnterPassword##" ssh ##ESXi Root##@##ESXi IP##
