#!/bin/bash

# Проверка аргументов на валидность
. validation.sh

# Переменные
SOURCE_PATH=$(pwd)
SIZE_FILES=${3:0:-2}
FOLDER_LETTERS=$1
DATE=$(date +%D | awk -F / '{print $2$1$3}')

FILE_LETTERS=""
EXTENSION_LETTERS=""

START_SEC=$(date +'%s%N')

echo "Start Script $(date +'%Y-%m-%d %H:%M:%S')" >> $SOURCE_PATH/logs_file.log

# Разделение формата файлов на список символов и расширение
for (( i = 0; i < ${#2}; i++ ))
do
    if [[ "${2:i:1}" == "." ]]; then
        EXTENSION_LETTERS=${2:i}
        break
    fi
    FILE_LETTERS=$FILE_LETTERS${2:i:1}
done


# Увеличение имени папки до нужного
while [ ${#FOLDER_LETTERS} -lt 5 ]
do
    FOLDER_LETTERS=$FOLDER_LETTERS${FOLDER_LETTERS:${#FOLDER_LETTERS} - 1:1}
done

# Увеличение имени файла до нужного
while [ ${#FILE_LETTERS} -lt 5 ]
do
    FILE_LETTERS=$FILE_LETTERS${FILE_LETTERS:${#FILE_LETTERS} - 1:1}
done





while [ true ]
do
    PATH_SCRIPT=$(compgen -d / | shuf -n1)
    cd $PATH_SCRIPT

    # while
    COUNT_FOLDERS=$(( $RANDOM % 100 + 1 ))

    for (( i = 0; i < $COUNT_FOLDERS; i++ ))
    do
        # Создание папок
        while [ -e $FOLDER_LETTERS"_"$DATE ]
        do
            # если такие названия уже есть
            FOLDER_LETTERS=${FOLDER_LETTERS:0:1}$FOLDER_LETTERS
        done

        TMP_NAME_FOLDER=$FOLDER_LETTERS"_"$DATE
        mkdir $TMP_NAME_FOLDER

        echo "$PATH_SCRIPT/$TMP_NAME_FOLDER/" `date +%Y-%m-%d-%H-%M` >> $SOURCE_PATH/logs_file.log
        TMP_NAME_FILE=$PATH_SCRIPT"/"$TMP_NAME_FOLDER"/"$FILE_LETTERS

        COUNT_FILES=$(( $RANDOM % 100 + 1))

        for (( j = 0; j < $COUNT_FILES; j++ ))
        do
            # Создание файлов
            while [ -e $TMP_NAME_FILE$EXTENSION_LETTERS ]
            do
                # если такие названия уже есть
                TMP_NAME_FILE=$TMP_NAME_FILE${TMP_NAME_FILE:${#TMP_NAME_FILE} - 1:1}
            done

            touch $TMP_NAME_FILE$EXTENSION_LETTERS
            fallocate -l $SIZE_FILES"M" $TMP_NAME_FILE$EXTENSION_LETTERS 2> /dev/null

            echo "$TMP_NAME_FILE$EXTENSION_LETTERS" `date +%Y-%m-%d-%H-%M` "$SIZE_FILES""MB" >>  $SOURCE_PATH/logs_file.log
            
            if [[ $(df / -BM | grep "/" | awk -F"M" '{ print $3 }') -le 1024 ]]; then
                END_SEC=$(date +'%s%N')
                DIFF_SEC=$((( $END_SEC - $START_SEC ) / 100000000 ))
                echo "End Script $(date +'%Y-%m-%d %H:%M:%S')" >> $SOURCE_PATH/logs_file.log
                echo "Script ran for $DIFF_SEC seconds" >> $SOURCE_PATH/logs_file.log
                cd $SOURCE_PATH
                exit 0

            TMP_NAME_FILE=$TMP_NAME_FILE${TMP_NAME_FILE:${#TMP_NAME_FILE} - 1:1}
        done

        FOLDER_LETTERS=$FOLDER_LETTERS${FOLDER_LETTERS:${#FOLDER_LETTERS} - 1:1}
    done
done
