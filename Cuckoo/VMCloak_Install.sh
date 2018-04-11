
#If the user wants to install a Windows VM, they must run the below vmcloak script following the below args:
#./CreateWindowsVM.sh <VM ID> <VM TYPE> <VM IP> <ISO IMAGE DIRECT PATH>

# This script will attempt to create a Windows 7 VM with specific parameters. The VM will have some dependencies installed to it.
# Written by samwakel following VMCloak install docs.

# Check that the script was executed with sudo
if [ $(id -u) -ne 0 ]
	then
	echo "This script must be run as root to mount the installer image. Are you using sudo?"
	exit
fi

# Check that the correct amount of arguments exist
if [[ $# -ne 4 ]]
	then
	echo "Usage: sudo ./CreateWindowsVM.sh <VM ID> <VM TYPE> <VM IP> <ISO IMAGE>"
	echo "All parameters are required."
	echo
	echo "VM ID is a unique number for each VM. Re-using existing will create an error upon creation, then attempt to re-install the dependencies to the existing machine, which usually hangs the VM. Maybe use a for loop?"
	echo "Possible VM types: win7x86 win7x64. Errors will be thrown if this is incorrect."
	echo "VM IP, the IP entered here will be the IP the VM uses."
	echo "ISO IMAGE, path to the .iso image that will be used for installing the VM's OS. This ISO is not automatically downloaded, it must be provided."
	echo
	echo "Please be patient, the VM will reboot multiple times while being created."
	exit
fi

# Install vmcloak + Dependencies
sudo apt-get install -y -qq build-essential libssl-dev libffi-dev
echo
sudo apt-get install -y -qq python-dev genisoimage
sudo pip install -q vmcloak
sudo -H pip -q install vmcloak --upgrade

# Mount the Windows 7 installer ISO for the VM to access on install.
sudo mkdir -p /mnt/win7
sudo mount -o loop,ro $4 /mnt/win7

# Ensure the hostonly network adapter is up.
vmcloak-vboxnet0

# Create the VM.
vmcloak init --$2 seven$1 --ip $3

# Unmount the ISO before installing dependencies, so we don't get asked for sudo password again on timeout.
sudo umount /mnt/win7

# Install the dependencies to the VM.
vmcloak install seven$1 adobe9 wic pillow dotnet40 java7 chrome removetooltips silverlight vcredist winrar kb:2729094 kb:2731771 kb:2670838 kb:2786081 kb:2639308 kb:2834140 kb:2882822 kb:2888049 #kb:2533623

# The last KB is commented, uncomment to have it installed automatically.
# It's a security update for patching the loading of a library in an insecure manner that could allow remote code execution.
# It's download is broken on the x32 version, throws a checksum error. Do not uncomment until fixed if you are installing 32bit Windows 7.
