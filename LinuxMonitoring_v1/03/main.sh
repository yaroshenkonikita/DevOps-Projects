#!/bin/sh

# valid
[ $# -ne 4 ] && echo "$0: Wrong count arguments: $# (need 4)" && exit 1
for i in "$@"; do
    if [ "$i" != "1" ] && [ $i != "2" ] && [ $i != "3" ] && [ $i != "4" ] && [ $i != "5" ] && [ $i != "6" ]; then 
        echo "$0: Wrong argument: $i (range 1 - 6)" && exit 1
    fi
done
[ $1 -eq $2 ] || [ $3 -eq $4 ] && echo "$0: Same colors: Try again" && exit 1

# variables from second script
. ../02/variables.sh

# find color
color_assigment() {
    case "$1" in
        1) result=7;;  # white
        2) result=1;;  # red
        3) result=2;;  # green
        4) result=4;;  # blue
        5) result=5;;  # purple
        *) result=0;;  # black default
    esac
    return $result
}



# output
output() {
    default="\033[37m\033[0m"

    echo "${1}${2}HOSTNAME${default} = ${3}${4}$HOSTNAME${default}"
    echo "${1}${2}TIMEZONE${default} = ${3}${4}$TIMEZONE${default}"
    echo "${1}${2}USER${default} = ${3}${4}$USER${default}"
    echo "${1}${2}OS${default} = ${3}${4}$OS${default}"
    echo "${1}${2}DATE${default} = ${3}${4}$DATE${default}"
    echo "${1}${2}UPTIME${default} = ${3}${4}$UPTIME${default}"
    echo "${1}${2}UPTIME_SEC${default} = ${3}${4}$UPTIME_SEC${default}"
    echo "${1}${2}IP${default} = ${3}${4}$IP${default}"
    echo "${1}${2}MASK${default} = ${3}${4}$MASK${default}"
    echo "${1}${2}GATEWAY${default} = ${3}${4}$GATEWAY${default}"
    echo "${1}${2}RAM_TOTAL${default} = ${3}${4}$RAM_TOTAL${default}"
    echo "${1}${2}RAM_USED${default} = ${3}${4}$RAM_USED${default}"
    echo "${1}${2}RAM_FREE${default} = ${3}${4}$RAM_FREE${default}"
    echo "${1}${2}SPACE_ROOT${default} = ${3}${4}$SPACE_ROOT${default}"
    echo "${1}${2}SPACE_ROOT_USED${default} = ${3}${4}$SPACE_ROOT_USED${default}"
    echo "${1}${2}SPACE_ROOT_FREE${default} = ${3}${4}$SPACE_ROOT_FREE${default}"
}


color_assigment $1
left_background_color="\033[4$?m"
color_assigment $2
left_font_color="\033[3$?m"
color_assigment $3
right_background_color="\033[4$?m"
color_assigment $4
right_font_color="\033[3$?m"

# result
output $left_background_color $left_font_color $right_background_color $right_font_color
