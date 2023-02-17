FOR TEST

#!/bin/bash

SUCCESS=0
FAIL=0
COUNTER=0
DIFF_RES=""

declare -a tests=(
"s ./test_grep/test_0_grep.txt VAR"
"for ./test_grep/grep.c ./test_grep/grep.h ./test_grep/Makefile VAR"
"for ./test_grep/grep.c VAR"
"-e for -e ^int ./test_grep/grep.c ./test_grep/grep.h ./test_grep/Makefile VAR"
"-e for -e ^int ./test_grep/grep.c VAR"
"-e regex -e ^print ./test_grep/grep.c VAR -f ./test_grep/test_ptrn_grep.txt"
"-e while -e void ./test_grep/grep.c ./test_grep/Makefile VAR -f ./test_grep/test_ptrn_grep.txt"
)

declare -a extra=(
"-n for ./test_grep/test_1_grep.txt ./test_grep/test_2_grep.txt"
"-n for ./test_grep/test_1_grep.txt"
"-n -e ^\} ./test_grep/test_1_grep.txt"
"-ce ^int ./test_grep/test_1_grep.txt ./test_grep/test_2_grep.txt"
"-e ^int ./test_grep/test_1_grep.txt"
"-nivh = ./test_grep/test_1_grep.txt ./test_grep/test_2_grep.txt"
"-e"
"-ie INT ./test_grep/test_5_grep.txt"
"-echar ./test_grep/test_1_grep.txt ./test_grep/test_2_grep.txt"
"-ne = -e out ./test_grep/test_5_grep.txt"
"-iv int ./test_grep/test_5_grep.txt"
"-in int ./test_grep/test_5_grep.txt"
"-c -l aboba ./test_grep/test_1_grep.txt ./test_grep/test_5_grep.txt"
"-v ./test_grep/test_1_grep.txt -e ank"
"-noe ) ./test_grep/test_5_grep.txt"
"-l for ./test_grep/test_1_grep.txt ./test_grep/test_2_grep.txt"
"-o -e int ./test_grep/test_4_grep.txt"
"-e = -e out ./test_grep/test_5_grep.txt"
"-e ing -e as -e the -e not -e is ./test_grep/test_6_grep.txt"
"-l for ./test_grep/no_file.txt ./test_grep/test_2_grep.txt"
"-f ./test_grep/test_3_grep.txt ./test_grep/test_5_grep.txt"
)

testing()
{
    t=$(echo $@ | sed "s/VAR/$var/")
    ./test_grep/grep_v-1 $t > test_grep/test_grep.log
    grep $t > test_grep/test_sys_grep.log
    DIFF_RES="$(diff -s test_grep/test_grep.log test_grep/test_sys_grep.log)"
    (( COUNTER++ ))
    if [ "$DIFF_RES" == "Files test_grep/test_grep.log and test_grep/test_sys_grep.log are identical" ]
    then
      (( SUCCESS++ ))
        echo "Fails: $FAIL"
        echo "Success: $SUCCESS"
        echo "Total: $COUNTER"
        echo "Current: success - cat $t"
    else
      (( FAIL++ ))
        echo "Fails: $FAIL"
        echo "Success: $SUCCESS"
        echo "Total: $COUNTER"
        echo "Current: fail - cat $t"
    fi
    rm test_grep/test_grep.log test_grep/test_sys_grep.log
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
