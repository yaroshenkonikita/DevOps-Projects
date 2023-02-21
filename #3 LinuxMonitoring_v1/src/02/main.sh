#!/bin/sh
# valid
[ $# -ne 0 ] && echo "$0: $1: Unknown argument" && exit 1

# output
output(){
    echo "HOSTNAME = $HOSTNAME"
    echo "TIMEZONE = $TIMEZONE"
    echo "USER = $USER"
    echo "OS = $OS"
	echo "DATE = $DATE"
	echo "UPTIME = $UPTIME"
	echo "UPTIME_SEC = $UPTIME_SEC"
	echo "IP = $IP"
	echo "MASK = $MASK"
	echo "GATEWAY = $GATEWAY"
	echo "RAM_TOTAL = $RAM_TOTAL"
	echo "RAM_USED = $RAM_USED"
	echo "RAM_FREE = $RAM_FREE"
	echo "SPACE_ROOT = $SPACE_ROOT"
	echo "SPACE_ROOT_USED = $SPACE_ROOT_USED"
	echo "SPACE_ROOT_FREE = $SPACE_ROOT_FREE"
}

# save
save(){
	read -p "Do you want to save this information? (Y/N): " status

	if [ "$status" = "Y" ] || [ "$status" = "y" ]
	then
        output >> "$(date +"%d_%m_%y_%H_%M_%S").status"
	fi

	return $result
}

. ./variables.sh
# result
output
save
