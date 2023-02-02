#!/bin/sh
    
# timer start
start=$(date +%s%N)

# valid
[ $# != 1 ] && echo "$0: Needs one path as parameter to work" && exit 1

! [ -e $1 ] && echo "$0: No such path exists" && exit 1

[ $(echo $1 | sed 's/^.*\(.\)$/\1/') != "/" ] && echo "$0: \"/\" is required at the end of the path" && exit 1

# spez functions
top_ten_files() {
    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    for i in {1..10}
    do
        file_info=$(find $1 2>/dev/null -type f -exec du -h {} + | sort -rh | head -10 | sed "${i}q;d")
        if [[ -n $file_info ]]; then
            echo -n "$i -"
            echo -n "$(echo $file_info | awk '{print $2",", $1}'), "
            echo "$(echo $file_info | grep -m 1 -o -E "\.[^/.]+$" | awk -F . '{print $2}')"
        fi
    done
}

top_ten_executable() {
    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)  "
    for i in {1..10}
    do
        file_info=$(find $1 2>/dev/null -type f -executable -exec du -h {} + | sort -rh | head -10 | sed "${i}q;d")
        if [[ -n $file_info ]]; then
            echo -n "$i -"
            path=$(echo $file_info | awk '{print $2}')
            echo -n "$(echo $file_info | awk '{print $2",", $1}'), "
            hash=$(md5sum $path | awk '{print $1}')
            echo "$hash"
        fi
    done
}

# output
echo "Total number of folders (including all nested ones) = $(ls -lRA $1 | grep -c ^d)"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
echo "$(find $1* -type d -exec du -ch {} + 2>/dev/null | grep -v total | sort -rh | head -5 | awk '{print NR, "-", $2"/, "$1}')"
echo "Total number of files = $(ls -lRA $1 | grep -ce ^-)"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $(ls -lRA $1 | grep -cF ".conf")" 
echo "Text files = $(ls -lRA $1 | grep -ce "^-r..r..r")"
echo "Executable files = $(ls -lRA $1 | grep -ce "^-..x..x..x")"
echo "Log files (with the extension .log) = $(ls -lRA $1 | grep -cF ".log")"
echo "Archive files = $(ls -lRA ../ | grep -ce "\.tar$" -e "\.gz$" -e "\.zip$" -e "\.rar$")"
echo "Symbolic links = $(ls -lRA $1 | grep -c ^l)"
top_ten_files $1
top_ten_executable $1

# output timer
end=$(date +%s%N)    
runtime=$(( $end - $start ))
echo -n "Script execution time (in second) = "
echo "$(echo $runtime | awk '{printf "%.3f", $1/1000000000}')"
