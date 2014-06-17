#### {% title "Oswajamy Neo4j" %}

* grafy
* dokumentacja

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

Być może będziemy musieli zainstalować aktualną wersję Javy
i zwiększyć limity na pliki:

    :::bash /etc/security/limits.conf
    *          soft    nofile  40000
    *          hard    nofile  40000



## Import danych
