#!/bin/bash
replace '(?!")(\w+):(?!")' '"$1":' $1 >> /dev/null
replace '(")(http)(s*)"' 'http$3' $1 >> /dev/null
replace '(})(\).call\(this\);)' '' $1 >> /dev/null
replace '(})(\);)' '}' $1  >> /dev/null
replace '(\(function\(\) {)' ' ' $1 >> /dev/null
replace '(\({)' '{' $1 >> /dev/null
cat $1 > $2
rm $1
