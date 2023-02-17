#!/bin/bash

SUCCESS=0
FAIL=0
COUNTER=0
DIFF_RES=""
PROGRAM_NAME=$1

declare -a tests=(
"s ./src/test_grep/test_0_grep.txt VAR"
"for ./src/test_grep/grep.c ./src/test_grep/grep.h ./src/test_grep/Makefile VAR"
"for ./src/test_grep/grep.c VAR"
"-e for -e ^int ./src/test_grep/grep.c ./src/test_grep/grep.h ./src/test_grep/Makefile VAR"
"-e for -e ^int ./src/test_grep/grep.c VAR"
)

declare -a extra=(
"-n for ./src/test_grep/test_1_grep.txt ./src/test_grep/test_2_grep.txt"
"-n for ./src/test_grep/test_1_grep.txt"
"-n -e ^\} ./src/test_grep/test_1_grep.txt"
"-ce ^int ./src/test_grep/test_1_grep.txt ./src/test_grep/test_2_grep.txt"
"-e ^int ./src/test_grep/test_1_grep.txt"
"-nivh = ./src/test_grep/test_1_grep.txt ./src/test_grep/test_2_grep.txt"
"-e"
"-ie INT ./src/test_grep/test_5_grep.txt"
"-echar ./src/test_grep/test_1_grep.txt ./src/test_grep/test_2_grep.txt"
"-ne = -e out ./src/test_grep/test_5_grep.txt"
"-iv int ./src/test_grep/test_5_grep.txt"
"-in int ./src/test_grep/test_5_grep.txt"
"-v ./src/test_grep/test_1_grep.txt -e ank"
"-l for ./src/test_grep/test_1_grep.txt ./src/test_grep/test_2_grep.txt"
"-o -e int ./src/test_grep/test_4_grep.txt"
"-e = -e out ./src/test_grep/test_5_grep.txt"
"-e ing -e as -e the -e not -e is ./src/test_grep/test_6_grep.txt"
"-l for ./src/test_grep/no_file.txt ./src/test_grep/test_2_grep.txt"
"-f ./src/test_grep/test_3_grep.txt ./src/test_grep/test_5_grep.txt"
)

testing()
{
    t=$(echo $@ | sed "s/VAR/$var/")
    $PROGRAM_NAME $t > src/test_grep/test_grep.log
    grep $t > src/test_grep/test_sys_grep.log
    DIFF_RES="$(diff -s src/test_grep/test_grep.log src/test_grep/test_grep.log)"
    (( COUNTER++ ))
    if [ "$DIFF_RES" == "Files src/test_grep/test_grep.log and src/test_grep/test_grep.log are identical" ]
    then
      (( SUCCESS++ ))
        echo "Fails: $FAIL"
        echo "Success: $SUCCESS"
        echo "Total: $COUNTER"
        echo "Current: success - grep $t"
    else
      (( FAIL++ ))
        echo "Fails: $FAIL"
        echo "Success: $SUCCESS"
        echo "Total: $COUNTER"
        echo "Current: fail - grep $t"
    fi
    rm src/test_grep/test_grep.log src/test_grep/test_sys_grep.log
}

# специфические тесты
for i in "${extra[@]}"
do
    var="-"
    testing $i
done

# 1 параметр
for var1 in v c l n h o
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing $i
    done
done

# 2 параметра
for var1 in v c l n h o
do
    for var2 in v c l n h o
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1 -$var2"
                testing $i
            done
        fi
    done
done

# 3 параметра
for var1 in v c l n h o
do
    for var2 in v c l n h o
    do
        for var3 in v c l n h o
        do
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ]
            then
                for i in "${tests[@]}"
                do
                    var="-$var1 -$var2 -$var3"
                    testing $i
                done
            fi
        done
    done
done

# 2 сдвоенных параметра
for var1 in v c l n h o
do
    for var2 in v c l n h o
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1$var2"
                testing $i
            done
        fi
    done
done

# 3 строенных параметра
for var1 in v c l n h o
do
    for var2 in v c l n h o
    do
        for var3 in v c l n h o
        do
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ]
            then
                for i in "${tests[@]}"
                do
                    var="-$var1$var2$var3"
                    testing $i
                done
            fi
        done
    done
done

echo "\033[31mFAIL: $FAIL\033[0m"
echo "\033[32mSUCCESS: $SUCCESS\033[0m"
echo "ALL: $COUNTER"

if [ "$FAIL" -ne "0" ]; then
    exit 1;
fi
