#!/bin/bash
#An example of using the expr command

a=10
b=20

echo "$a = 10"
echo "$b = 20"
val1=$(expr $b / $a)
echo " b / a : $val1"

val2=$(expr $a + $b)
echo " a + b : $val2"

val3=$(expr $a \* $b)
echo " a * b : $val3"

val4=$(expr $b - $a)
echo " b - a : $val4"

if [ $a == $b ]
then
        echo "a 等于 b"
fi

if [ $a != $b ]
then
        echo "a 不等于 b"
fi
