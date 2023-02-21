#!/bin/bash

[[ ($# -ne 1 || ($1 != "1" && $1 != "2" && $1 != "3")) && ($# -ne 3 || $1 != "2") && ($# -ne 2 || $1 != "3") ]] && echo "Incorrect parameter" && exit 1

case $1 in
  1)
    [[ ! -e "logs_file.log" ]] && echo "Файл logs_file.log не найден" && exit 1
    # Очистка по лог файлу
    LOGS=$(cat logs_file.log | awk '{print $1}')
    for i in $LOGS 
    do
    if [[ $i == /* ]]; then
        rm -rf $i
    fi
    done
    ;;
  2)
    # Очистка по дате создания
    if [[ $1 == "2" && $# -eq 1 ]]; then
        read -p "(start: YYYY-MM-DD HH:MM) " START 
        read -p "(end: YYYY-MM-DD HH:MM) " END
    else
        START=$2
        END=$3
    fi
    FORMAT=^[0-9]{4}['-'][0-9]{2}['-'][0-9]{2}[' '][0-9]{2}[':'][0-9]{2}$

    [[ ! $START =~ $FORMAT || ! $END =~ $FORMAT ]] && echo "Неверный формат даты" && exit 1

    DATE_TMP=`find / -newermt "$START" ! -newermt "$END" 2>/dev/null | sort -r`
    for i in $DATE_TMP
    do
    if [[ $i == /* ]];then
        rm -rf $i
    fi
    done
    ;;
  3)
    # Очистка по имени файла/папки (буквы, нижнее подчеркивание, дата)
    if [[ $1 == "3" && $# -eq 2 ]]; then
      echo "input slould be like: foldername_$(date '+%d%m%y') or filename_$(date '+%d%m%y').ext"
      read -p "enter the namemask: " NAMEMASK
    else
      NAMEMASK=$2
    fi
    NAME=$(echo $NAMEMASK | awk -F"_" '{ print $1 }')
    END=$(echo $NAMEMASK | awk -F"_" '{ print $2 }')
    rm -rf $(find / -type f -name "*$NAME*$END" 2>/dev/null)
    rm -rf $(find / -type d -name "*$NAME*$END" 2>/dev/null)
    ;;
esac

exit 0
