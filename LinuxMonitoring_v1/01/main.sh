#!/bin/sh

[ "$#" != "1" ] && exit 1
echo $1 | grep -E -q '^[0-9]+$' && echo "$0: $1: Numeric argument" && exit 1
echo $1
