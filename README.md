# Wiosna, 2012/13


## 1. Elasticsearch

Instalacja, instalacja wtyczek, własne skrypty,
[gist](https://gist.github.com/wbzyl/5099266)
(problemy z nfs na sigmie?)


## 2. Elasticsearch na Sigmie

Przykładowe dane umieściłem w ES na Sigmie.
A tak można odpytać ES z Sigmy.

Zapytania będą krótsze z taką definicją:

```sh
export ES=http://sigma.ug.edu.pl:9200
```

Teraz zapytanie będzie wyglądać tak:

```sh
curl "$ES/_search?pretty=true&q=label:Interscope"
curl "$ES/amazon/_search?pretty=true&q=name:energy"
curl "$ES/amazon/books,cds/_search?pretty=true&q=name:energy"
```


# Poradnik redaktora

Wykorzystać, wykorzystanie:

* używać, użytkować, korzystać, stosować
* używanie, użytkowanie, korzystanie, stosowanie

Wymaganie:

Zasadnicze wymaganie – to odporność na błędy użytkownika.

Zastąpić co czym.

Złożony:

* trudny, skomplikowany, zawiły

Zmiana czego:

* zmiana pogladów, przekonań
