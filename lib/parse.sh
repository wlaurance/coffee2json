#!/bin/bash
replace '(?!")(\w+):(?!")' '"$1":' $1
replace '(")(http)(s*)"' 'http$3' $1 
replace '(})(\).call\(this\);)' '' $1 
replace '(})(\);)' '' $1  
replace '(\(function\(\) {)' ' ' $1 
replace '(\({)' '{' $1
cat $1 > $2
rm $1
