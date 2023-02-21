#!/bin/bash

# Проверка на количество аргументов
[ $# != 3 ] && echo "Не правильное количество аргументов" && exit 1

. check_letters_folder.sh $1

. check_letters_file.sh $2

. check_size_mb.sh $3
