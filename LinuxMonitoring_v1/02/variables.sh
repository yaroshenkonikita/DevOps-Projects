# variables
HOSTNAME=$(hostname)
TIMEZONE="$(cat /etc/timezone) $(date +"%Z %z")"
USER=$(whoami)
OS=$(cat /etc/issue | awk '{print $1,$2}' | tr -s '\n\r' ' ')
DATE=$(date +"%d %B %Y %T")
UPTIME=$(uptime -p | sed 's/...//')
UPTIME_SEC=$(cat /proc/uptime | awk '{print $1}')
IP=$(ip addr show | grep -e "inet " | grep -v " lo" | awk '{print $2}' | awk -F '/' '{print $1;}')
MASK=$(netstat -rn | tail +4 | head -1 | awk '{print $3}')
GATEWAY=$(netstat -rn | tail +4 | head -1 | awk '{print $2}')

RAM=$(free -m | tail +2 | head -1)
RAM_TOTAL=$(echo $RAM | awk '{printf "%.3f GB", $2/1024}')
RAM_USED=$(echo $RAM | awk '{printf "%.3f GB", $3/1024}')
RAM_FREE=$(echo $RAM | awk '{printf "%.3f GB", $4/1024}')

SPACE=$(df ~ | tail +2 | head -1)
SPACE_ROOT=$(echo $SPACE | awk '{printf "%.2f MB ", $2/1024}')
SPACE_ROOT_USED=$(echo $SPACE | awk '{printf "%.2f MB ", $3/1024}')
SPACE_ROOT_FREE=$(echo $SPACE | awk '{printf "%.2f MB ", $4/1024}')