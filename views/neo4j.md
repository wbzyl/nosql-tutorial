#### {% title "Oswajamy Neo4j" %}

* [Graf](http://pl.wikipedia.org/wiki/Graf_%28matematyka%29) – definicje na Wikipedii.
* [Dokumentacja](http://docs.neo4j.org/):
  - [wersja 2.1.2](http://neo4j.com/docs/2.1.2/)
* [Książki](http://neo4j.com/books/).


## Szybka instalacja

Ze strony [Neo4j Download](http://www.neo4j.org/download)
pobieramy *Neo4j Community Edition*, które rozpakowujemy
w katalogu *~/.neo4j* i tworzymy symboliczne linki:

    :::bash
    cd ~/.neo4j
    tar zxvf neo4j-community-2.1.2-unix.tar.gz
    mkdir bin
    cd bin
    ln -s ../neo4j-community-2.1.2/bin/* .

Teraz możemy już uruchomić serwer *neo4j*:

    :::bash
    bin/neo4j start

Być może będziemy musieli zainstalować aktualną wersję Javy z Oracle
(zob. alternatives w Fedorze) i zwiększyć limity na pliki:

    :::bash /etc/security/limits.conf
    *          soft    nofile  40000
    *          hard    nofile  40000

Wchodzimy na stronę:

    http://localhost:7474/

gdzie ogarniamy podstawy grafowych baz danych.


## Import danych

* [Neo4j 2.1 – Graph ETL for Everyone](http://neo4j.com/blog/neo4j-2-1-graph-etl/)
  (ang. ETL – Extract, Transform and Load)
