#### {% title "Views ≡ Map + Reduce" %}

<blockquote>
 {%= image_tag "/images/carlos_castaneda.jpg", :alt => "[Carlos Castaneda]" %}
 <p>
  Niektórzy czarownicy, wyjaśnił, są gawędziarzami.
  Snucie historii to dla nich nie tylko wysyłanie
  zwiadowców badających granice ich percepcji,
  ale także sposób na osiągnięcie doskonałości,
  zdobycia mocy i dotarcia do ducha.
 </p>
 <p class="author">— Carlos Castaneda</p><!-- Potęga milczenia, p. 126 -->
</blockquote>

Zapytania SQL, takie jak to:

    SELECT name, email, fax FROM contacts

nie mają sensu dla dokumentowych baz danych.

Dlaczego? Rozważyć wartości NULL. Rekordy w tabelach SQL a dokumenty w
dokumentowych bazach danych.

W dokumentowych bazach danych zamiast pisać zapytania
piszemy widoki. Cytat:
„Views are the primary tool used for querying and reporting on CouchDB
documents. There are two different kinds of views: permanent and
temporary views.”

Widoki są zapisywane w bazie jako specjalne **design documents**.
Widoki są powielane z zwykłymi dokumentami.


## „Myśli nieuczesane”

Widoki będziemy ćwiczyć na przykładzie dokumentowej bazy danych
zawierającej kilkanaście aforyzmów Stanisława J. Leca
oraz Hugo Steinhausa:

Aforyzmy wybrałem ze
[strony wikipedi](http://pl.wikiquote.org/wiki/Stanis%C5%82aw_Jerzy_Lec)
poświęconej S. J. Lecowi oraz ze
[strony wikipedi](http://pl.wikiquote.org/wiki/Hugo_Steinhaus) —
H. Steinhausowi.

Oto przykładowy dokument:

    :::json
    {
      "_id": "1",
      "created_at": [2010, 0, 31],
      "body": "Szerzenie niewiedzy o wszechświecie musi być także naukowo opracowane.",
      "tag": ["wiedza","nauka","wszechświat"]
    }

Zaczynamy od utworzenia bazy:

    curl -X PUT http://wbzyl:sekret@127.0.0.1:5984/lec

i sprawdzenia w Futonie czy baza została rzeczywiście utworzona:

    http://127.0.0.1:5984/_utils

Dokumenty w zapiszemy hurtowo w bazie:

    curl -X POST -d @lec.json http://127.0.0.1:5984/lec/_bulk_docs

Tutaj można pobrać plik {%= link_to "lec.json", "/doc/couchdb/lec.json" %}
użyty w powyższym poleceniu.


## Widoki w CouchDB API

W CouchDB mamy dwa rodzaje widoków:

* tymczasowe (*temporary views*)
* permanentne (*permanent views*)

Pierwszy widok który uruchomimy, to **domyślny** widok tymczasowy:

    :::javascript
    function(doc) {
      emit(null, doc);
    }

Znajdziemy go w Futonie po kliknięciu w link do bazy *lec*, a następnie
wybranie *Temporary view* z listy rozwijanej *View* (prawy górny róg).
Widok uruchamiamy klikając w przycisk *Run*.

Widoki tymczasowe generowane są na bieżąco. Ponieważ generowanie
widoku może trwać długo, więc zwykle korzystamy z widoków
permanentnych, które generowane są tylko raz, a następnie są tylko
uaktualniane. Uaktualnienie widoku permanentnego zajmuje mało czasu.

Utwórzmy nowy widok, podmieniając kod domyślnego widoku na:

    :::javascript
    function(doc) {
      if(doc.created_at && doc.body) {
        emit(doc.created_at, {summary:doc.body.substring(0,20) + "..."});
      }
    }

Sprawdźmy, czy widok działa uruchamiając go.
Jeśli widok działał, to zamieńmy go na widok permanentny.

Widok permanentny utworzymy klikając w przycisk *Save As…*
i wpisując w okienku *Save View As…* **example** i **by_date**:

<pre>Design Document:  _design/<b>example</b>
      View Name:  <b>by_date</b>
</pre>

Widoki możemy też wykonywać z wiersza poleceń,
dla przykładu:

    curl http://127.0.0.1:5984/lec/_design/example/_view/by_date

Ale dla widoków tymczasowych polecenie to jest inne
(*POST* zamiast *GET*):

    curl -X POST http://127.0.0.1:5984/lec/_temp_view \
      -d '{"map":"function(doc) { emit(null, doc); }"}'

Z linii poleceń możemy też wstawiać do bazy widoki permanentne,
dla przykładu:

    curl -X PUT http://wbzyl:sekret@127.0.0.1:5984/lec/_design/example -d @views.json

gdzie użyty powyżej plik *views.json* ma następującą zawartość:

    :::json
    {
      "language": "javascript",
      "views": {
        "by_date": {
          "map": "function(doc) {
                     emit(doc.created_at, doc.body);
                 }"
        },
        "by_body": {
          "map": "function(doc) {
                      emit(doc.body, doc.created_at);
                 }"
        }
      }
    }

Zauważmy, że widok może zawierać kilka funkcji *map*.

Uwaga: wcześniej należy usunąć z bazy już istniejący widok *by_date*.

Skorzystajmy z widoku *example*. Zaczynamy od *by_date*:

    curl http://127.0.0.1:5984/lec/_design/example/_view/by_date

W odpowiedzi zwracany jest JSON:

    :::json
    {"total_rows":8,"offset":0,"rows":[
    {"id":"3","key":[2009,6,15],"value":"Za du\u017co or\u0142\u00f3w, za ma\u0142o drobiu."},
    ....
    {"id":"5","key":[2010,11,31],"value":"Znasz has\u0142o do swojego wn\u0119trza?"}
    ]}

i *by_body*:

    curl http://127.0.0.1:5984/lec/_design/example/_view/by_body

CouchDB dodaje pole *id* do pól *key* i *value*.
Pole *id* przydaje się przy tworzeniu linków do zasobów.


## *Querying Options* w widokach

Argumenty w zapytaniach URI:
[HTTP view API](http://wiki.apache.org/couchdb/HTTP_view_API).

Dla żądań GET:

* key=*keyvalue*
* startkey=*keyvalue*
* endkey=*keyvalue*
* limit=*max row to return*
* stale=ok
* descending=true
* skip=*number of rows to skip*
* group=true
* group\_level=*integer*
* reduce=false
* include_docs=true
* inclusive_end=true
* startkey_docid=*docid*
* endkey_docid=*docid*

Dla żądań POST oraz do wbudowanego widoku *_all_docs*:

* {"keys": ["key1", "key2", ...]} – tylko wyszczególnione wiersze widoku


### Przykłady użycia argumentów w żądaniach

Uwaga: parametry zapytań muszą być odpowiedni cytowane/kodowane.
Jest to uciążliwe. Program *curl* od wersji 7.20 pozwala nam obejść
tę uciążliwość. Należy skorzystać z opcji `-G` oraz `--data-urlencode`.
Przykład:

    curl -X GET http://localhost:5984/books/_design/default/_view/authors -G \
      --data-urlencode startkey='"j"' --data-urlencode endkey='"j\ufff0"' \
      -d reduce=false

TODO: do poleceń poniżej dopisać nowe wersje z urlencode.

**key**: dokument(y) powiązany(e) z kluczem:

    curl http://localhost:5984/lec/_design/example/_view/by_date?key='\[2010,0,1\]'

**startkey**: dokumenty od klucza:

    curl http://localhost:5984/lec/_design/example/_view/by_date?startkey='\[2010,0,31\]'

**endkey**: dokumenty do klucza (wyłącznie):

    curl http://localhost:5984/lec/_design/example/_view/by_date?endkey='\[2010,0,31\]'

**limit**: co najwyżej tyle dokumentów zaczynając od podanego klucza:

    curl http://localhost:5984/lec/_design/example/_view/by_date?startkey='\[2010,0,31\]'\&limit=2

**skip**: pomiń podaną liczbę dokumentów zaczynając od podanego klucza:

Zostały jeszcze boolowskie: **include_docs** oraz **inclusive_end**

Uwaga: **group**, **group_level** i **reduce**  można użyć tylko
z widokami z funkcją *reduce*.

**Przykład widoku z funkcją map i reduce**

Funkcja map:

    :::javascript
    function(doc) {
      if(doc.created_at && doc.body) {
        emit(doc.created_at, 1);
      }
    }

Funkcja reduce:

    :::javascript
    function(keys, values, rereduce) {
      return sum(values);
    }

Zapiszmy ten widok w **_design/example** jako **count** i wykonajmy
go z wiersza poleceń:

    curl http://localhost:5984/lec/_design/example/_view/count
    {"rows":[
      {"key": null, "value": 8}
    ]}

**group**:

    curl http://localhost:5984/lec/_design/example/_view/count?group=true
    {"rows":[
      {"key": [2009,6,15],  "value": 1},
      {"key": [2010,0,1],   "value": 2},
      {"key": [2010,0,31],  "value": 1},
      {"key": [2010,1,20],  "value": 1},
      {"key": [2010,1,28],  "value": 2},
      {"key": [2010,11,31], "value": 1}
    ]}


## Sortowanie – *view collation*

Poniższy przykład, napisany w języku Ruby,
pochodzi z [CouchDB Wiki](http://wiki.apache.org/couchdb/View_collation).

Zaczynamy od instalacji gemów użytych w przykładzie:

    gem install rest-client json

Następnie za pomocą poniższego skryptu tworzymy bazę *collator* (ruby 1.9.2):

    :::ruby collseq.rb
    require 'restclient'
    require 'json'

    # jeśli Admin Party!
    DB="http://127.0.0.1:4000/collator"
    # w przeciwnym wypadku wpisujemy swoje dane
    # DB="http://User:Pass@127.0.0.1:4000/collator"
    RestClient.delete DB rescue nil
    RestClient.put "#{DB}",""
    (32..126).each do |c|
      RestClient.put "#{DB}/#{c.to_s(16)}", {"x"=>c.chr}.to_json
    end

    RestClient.put "#{DB}/_design/test", <<EOS
    {
      "views":{
        "one":{
          "map":"function (doc) { emit(doc.x,null); }"
        }
      }
    }
    EOS
    puts RestClient.get("#{DB}/_design/test/_view/one")

Kilka zapytań do bazy. Wpisujemy na konsoli:

    curl -X GET http://localhost:4000/collator/_all_docs?startkey=\"64\"\&limit=4
    curl -X GET http://localhost:4000/collator/_all_docs?startkey=\"64\"\&limit=2\&descending=true
    curl -X GET http://localhost:4000/collator/_all_docs?startkey=\"64\"\&endkey=\"68\"

W przeglądarce powyższe URL-e wpisujemy bez „cytowania“:

    http://localhost:4000/collator/_all_docs?startkey="64"&limit=4
    http://localhost:4000/collator/_all_docs?startkey="64"&limit=2&descending=true
    http://localhost:4000/collator/_all_docs?startkey="64"&endkey="68"

Dokumentacja [rest-client](https://github.com/archiloque/rest-client) + konsola Rubiego.
Przykład do wpisania na konsoli *irb*:

    :::ruby
    DB = "http://localhost:4000/lz"
    RestClient.get DB
    response = RestClient.get "#{DB}/led-zeppelin-i"
    response.code
    response.headers
    response.cookies


### Ciekawe zapytania

**Przykład 1.** Korzystamy z *collation sequence*
(kolejności zestawiania, schematu uporządkowania).

    curl http://localhost:5984/lec/_design/example/_view/by_date?startkey='\[2010\]'\&endkey='\[2010,1\]'
    {"total_rows":8,"offset":1,"rows":[
      {"id":"1","key":[2010,0,1],"value":{"summary":"Szerzenie niewiedzy ..."}},
      {"id":"4","key":[2010,0,1],"value":{"summary":"Zdanie to najwi\u0119ksza..."}},
      {"id":"8","key":[2010,0,31],"value":{"summary":"Jedn\u0105 z cech g\u0142upstw..."}}
    ]}

**Przykład 2.** Do widoku **by_date** dodajemy taką oto funkcję reduce:

    :::javascript
    function(keys, values, rereduce) {
      if (rereduce) {
        return sum(values);
      } else {
        return values.length;
      }
    }

Zapisujemy ten widok w **_design/example** pod nazwą **ucount**
(**u** – uniwersalny) i wykonujemy go:

    curl http://localhost:5984/lec/_design/example/_view/ucount?group=true


**Przykład 3.** Korzystamy z *POST*:

    curl -X POST -d '{"keys":["1","8"]}' \
      http://localhost:5984/lec/_all_docs
    curl -X POST -d '{"keys":["1","8"]}' \
      http://localhost:5984/lec/_all_docs?include_docs=true

Albo korzystając z widoku **by_date**:

    curl -X POST -d '{"keys":[[2010,0,1],[2010,0,31]]}' \
      http://localhost:5984/lec/_design/example/_view/by_date
    curl -X POST -d '{"keys":[[2010,0,1],[2010,0,31]]}' \
      http://localhost:5984/lec/_design/example/_view/by_date?include_docs=true

Na czym polegają różnice w otrzymanych wynikach?


### Różne rzeczy

W dokumentacji [HTTP view](http://wiki.apache.org/couchdb/HTTP_view_API):

* Debugowanie widoków
* View Cleanup
* View Compaction


## „Złączenia” w bazach CouchDB

*Przykład:* How you'd go about modeling a simple blogging system with „post” and
„comment” entities, where any blog post might have many comments.

Przykład ten pochodzi z artykułu:
Christopher Lenz. [CouchDB „Joins”](http://www.cmlenz.net/archives/2007/10/couchdb-joins).
W artykule autor omawia trzy sposoby modelowania powiązań
między postami a komentarzami.


### Sposób 1: komentarze inline

Utworzymy bazę zawierającą kilka takich dokumentów:

    :::json
    {
      "author": "jacek",
      "title": "Rails 2",
      "content": "Bla bla…",
      "comments": [
        {"author": "agatka", "content": "…"},
        {"author": "bolek",  "content": "…"}
      ]
    }

Dane do umieścimy w bazie za pomocą skryptu
{%= link_to 'blog-inline.rb', '/doc/couchdb/blog-inline.rb' %}.

Widok zwracający wszystkie komentarze, posortowane po polu *author*:

    :::javascript
    function(doc) {
      for (var i in doc.comments) {
        emit(doc.comments[i].author, doc.comments[i].content);
      }
    }

Jakie problemy może dawać takie podejście?
Aby dodać komentarz do posta, należy wykonać:

1. pobrać dokument post z bloga-inline
2. dodać nowy komentarz do struktury JSON
3. umieścić uaktualniony dokument w bazie

W jakim wypadku może to być problematyczne podejście?

To też może być problemem:
„Now if you have multiple client processes adding comments at roughly
the same time, some of them will get a 409 Conflict error on step 3
(that's optimistic concurrency in action).”


### Sposób 2: komentarze w osobnych dokumentach

Utworzymy bazę zawierającą kilka postów postaci:

    :::json
    {
      "_id": "01",
      "type": "post",
      "author": "jacek",
      "title": "Rails 3",
      "content": "Bla bla bla …"
    }

oraz komentarzy postaci:

    :::json
    {
      "_id": "11",
      "type": "comment",
      "post": "01",
      "author": "agatka",
      "content": "…"
    }
    {
      "_id": "12",
      "type": "comment",
      "post": "01",
      "author": "bolek",
      "content": "…"
    }

Dane do umieścimy w bazie za pomocą skryptu
{%= link_to 'blog-separate.rb', '/doc/couchdb/blog-separate.rb' %}.

Poniższy widok, wypisuje komentarze zgrupowane po polu *post*:

    :::javascript
    function(doc) {
      if (doc.type == "comment") {
        emit(doc.post, {author: doc.author, content: doc.content});
      }
    }

Widok ten po zapisaniu jako design document o nazwie **blog**
i o view name – **by_post** wywołujemy z wiersza poleceń:

    curl http://localhost:5984/blog-separate/_design/blog/_view/by_post

Albo tak, jeśli zamierzamy pobrać wszystkie komentarze do posta "02":

    curl http://localhost:5984/blog-separate/_design/blog/_view/by_post?key=\"02\"
    {"total_rows":7,"offset":2,"rows":[
    {"id":"13","key":"02","value":{"author":"lolek","content":"\u2026"}},
    {"id":"14","key":"02","value":{"author":"bolek","content":"\u2026"}}
    ]}

Albo tak:

    curl http://localhost:5984/blog-separate/_design/blog/_view/by_post?key='"02"'

Ech, to cytowanie w powłoce…

Przeglądanie wszystkich komentarzy posrtowanych po
polu *author*:

    :::javascript
    function(doc) {
      if (doc.type == "comment") {
        emit(doc.author, {post: doc.post, content: doc.content});
      }
    }

Po zapisaniu widoku pod nazwą *by_author*, wykonujemy go z wiersza poleceń:

    curl http://localhost:5984/blog-separate/_design/blog/_view/by_author

Przechowywanie osobno postów i komentarzy do nich też ma wady:

„Imagine you want to display a blog post with all the associated
comments on the same web page. With our first approach, we needed
just a single request to the CouchDB server, namely a GET request to
the document. With this second approach, we need two requests: a GET
request to the post document, and a GET request to the view that
returns all comments for the post.”


### Optymizacja: using the power of view collation

What we'd probably want then would be a way to join the blog post and
the various comments together to be able to retrieve them with
**a single HTTP request**.

    :::javascript
    function(doc) {
      if (doc.type == "post") {
        emit([doc._id, 0], doc);
      } else if (doc.type == "comment") {
        emit([doc.post, 1], doc);
      }
    }

Jak to działa? Po zapisaniu widoku jako *\_design/blog/\_view/povc*
wywołujemy go tak:

    curl http://localhost:5984/blog-separate/_design/blog/_view/povc?key='\["02",0\]'
    curl http://localhost:5984/blog-separate/_design/blog/_view/povc?key='\["02",1\]'

albo tak:

    curl http://localhost:5984/blog-separate/_design/blog/_view/povc?startkey='\["02"\]'\&endkey='\["03"\]'

Ostatnie wywołanie zwraca nam post o *id* równym "02"
i wszystkie jego komentarze w jednym żądaniu HTTP.
