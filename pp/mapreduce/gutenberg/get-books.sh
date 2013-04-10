#! /bin/bash

curl -o the-man-who-knew-too-much.txt http://www.gutenberg.org/cache/epub/1720/pg1720.txt
curl -o the-idiot.txt http://www.gutenberg.org/cache/epub/2638/pg2638.txt
# curl -o war-and-peace.txt http://www.gutenberg.org/cache/epub/2600/pg2600.txt
# curl -o the-sign-of-the-four.txt http://www.gutenberg.org/cache/epub/2097/pg2097.txt

# replace DOS newlines with UNIX newlines

zip x *.txt
unzip -a -o x
rm -f x.zip

# curl -o the-innocence-of-father-brown.txt http://www.gutenberg.org/cache/epub/204/pg204.txt
# curl -o memoirs-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/834/pg834.txt
# curl -o the-return-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/108/pg108.txt
# curl -o the-adventures-of-sherlock-holmes.txt http://www.gutenberg.org/cache/epub/1661/pg1661.txt
# curl -o a-study-in-scarlet.txt http://www.gutenberg.org/cache/epub/244/pg244.txt
