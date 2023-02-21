#!/bin/bash

# Проверка аргументов на валидность
. validation.sh

# Переменные
SOURCE_PATH=$(pwd)
PATH_SCRIPT=$1
COUNT_FOLDERS=$2
COUNT_FILES=$4
# SIZE_FILES=$((${6:0:-2} * 1024))
SIZE_FILES=${6:0:-2}
FOLDER_LETTERS=$3
DATE=$(date +%D | awk -F / '{print $2$1$3}')

FILE_LETTERS=""
EXTENSION_LETTERS=""

# Разделение формата файлов на список символов и расширение
for (( i = 0; i < ${#5}; i++ ))
do
    if [[ "${5:i:1}" == "." ]]; then
        EXTENSION_LETTERS=${5:i}
        break
    fi
    FILE_LETTERS=$FILE_LETTERS${5:i:1}
done

cd $PATH_SCRIPT

# Увеличение имени папки до нужного
while [ ${#FOLDER_LETTERS} -lt 4 ]
do
    FOLDER_LETTERS=$FOLDER_LETTERS${FOLDER_LETTERS:${#FOLDER_LETTERS} - 1:1}
done

# Увеличение имени файла до нужного
while [ ${#FILE_LETTERS} -lt 4 ]
do
    FILE_LETTERS=$FILE_LETTERS${FILE_LETTERS:${#FILE_LETTERS} - 1:1}
done

for (( i = 0; i < $COUNT_FOLDERS; i++ ))
do
    # Создание папок
    while [ -e $FOLDER_LETTERS"_"$DATE ]
    do
        # если такие названия уже есть
        FOLDER_LETTERS=$FOLDER_LETTERS${FOLDER_LETTERS:${#FOLDER_LETTERS} - 1:1}
    done
    TMP_NAME_FOLDER=$FOLDER_LETTERS"_"$DATE
    mkdir $TMP_NAME_FOLDER
    echo "$PATH_SCRIPT/$TMP_NAME_FOLDER/" `date +%Y-%m-%d-%H-%M` >> $PATH_SCRIPT/logs_file.log
    TMP_NAME_FILE=$TMP_NAME_FOLDER"/"$FILE_LETTERS
    for (( j = 0; j < $COUNT_FILES; j++ ))
    do
        # Создание файлов
        while [ -e $TMP_NAME_FILE$EXTENSION_LETTERS ]
        do
            # если такие названия уже есть
            TMP_NAME_FILE=$TMP_NAME_FILE${TMP_NAME_FILE:${#TMP_NAME_FILE} - 1:1}
        done
        touch $TMP_NAME_FILE$EXTENSION_LETTERS
        fallocate -l $SIZE_FILES"K" $TMP_NAME_FILE$EXTENSION_LETTERS 2> /dev/null
        echo "$PATH_SCRIPT/$TMP_NAME_FILE$EXTENSION_LETTERS" `date +%Y-%m-%d-%H-%M` "$SIZE_FILES""kB" >>  $PATH_SCRIPT/logs_file.log
        
        [[ $(df / |  head -2 | tail +2 | awk '{printf("%d", $4)}') -le 1048576 ]] && exit 1
        TMP_NAME_FILE=$TMP_NAME_FILE${TMP_NAME_FILE:${#TMP_NAME_FILE} - 1:1}
    done
    FOLDER_LETTERS=$FOLDER_LETTERS${FOLDER_LETTERS:${#FOLDER_LETTERS} - 1:1}
done

exit 0
