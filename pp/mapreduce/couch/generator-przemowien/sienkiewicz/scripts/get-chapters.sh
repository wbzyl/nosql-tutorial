#! /bin/bash

for x in 01 02 03 04 05 06 07 08 09 {10..96}
do
  echo "http://literat.ug.edu.pl/potop/00${x}.htm"
  links -dump -codepage latin2 http://literat.ug.edu.pl/potop/00${x}.htm | iconv -f latin2 -t utf8 >> potop.txt
done


