#!/bin/sh

. ./config.conf
# valid
[ $# -ne 0 ] && echo "$0: $1: Unknown argument" && exit 1
for i in $column1_background $column1_font_color $column2_background $column2_font_color; do
    if [ "$i" != "1" ] && [ $i != "2" ] && [ $i != "3" ] && [ $i != "4" ] && [ $i != "5" ] && [ $i != "6" ] && [ $i != "" ]; then 
        echo "$0: Wrong argument: $i (range 1 - 6)" && exit 1
    fi
done

# variables from second script
. ../02/variables.sh

# Default settings
default_column1_background="1"
default_column1_font_color="3"
default_column2_background="2"
default_column2_font_color="3"

# exception on space
[ "$column1_background" = "" ] && column1_background=$default_column1_background && default_column1_background=""
[ "$column1_font_color" = "" ] && column1_font_color=$default_column1_font_color && default_column1_font_color=""
[ "$column2_background" = "" ] && column2_background=$default_column2_background && default_column2_background=""
[ "$column2_font_color" = "" ] && column2_font_color=$default_column2_font_color && default_column2_font_color=""

# valid on same colors
[ "$column1_background" = "$column1_font_color" ] || [ "$column2_background" = "$column2_font_color" ] && echo "$0: Same colors: Try again" && exit 1

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

# print color
print_color() {
	case "$1" in
		1) echo " (white)";;
		2) echo " (red)";;
		3) echo " (green)";;
		4) echo " (blue)";;
		5) echo " (purple)";;
		6) echo " (black)";;
	esac
}


# print color settings
print_color_info() {
    if [ "$default_column1_background" = "" ]; then
	    echo -n "\nColumn 1 background = default"
    else
	    echo -n "\nColumn 1 background = $1"
    fi
	print_color $1
    
    if [ "$default_column1_font_color" = "" ]; then
	    echo -n "Column 1 font color = default"
    else
	    echo -n "Column 1 font color = $2"
    fi
    print_color $2
    if [ "$default_column2_background" = "" ]; then
	    echo -n "Column 2 background = default"
    else
	    echo -n "Column 2 background = $3"
    fi
    print_color $3
    if [ "$default_column2_font_color" = "" ]; then
	    echo -n "Column 2 font color = default"
    else
	    echo -n "Column 2 font color = $4"
    fi
	print_color $4
}

color_assigment $column1_background
left_background_color="\033[4$?m"
color_assigment $column1_font_color
left_font_color="\033[3$?m"
color_assigment $column2_background
right_background_color="\033[4$?m"
color_assigment $column2_font_color
right_font_color="\033[3$?m"

# result
output $left_background_color $left_font_color $right_background_color $right_font_color
print_color_info $column1_background $column1_font_color $column2_background $column2_font_color
