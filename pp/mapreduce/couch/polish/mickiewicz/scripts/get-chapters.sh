#! /bin/bash

for x in 01 02 03 04 05 06 07 08 09 {10..14}
do
  book="http://literat.ug.edu.pl/panfull/00${x}.htm"
  echo $book
  links -dump -codepage latin2 $book | iconv -f latin2 -t utf8 >> pan_tadeusz.txt
done
