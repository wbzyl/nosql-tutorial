#### {% title "Korzystamy z REST API" %}

Korzystamy z dokumentacji API CouchDB:
[HTTP Document API](http://wiki.apache.org/couchdb/HTTP_Document_API).

Pzykładowe dokumenty będziemy zapisywać w bazie o nazwie **lz**.
Umieścimy w niej trochę danych o zespole rockowym „Led Zeppelin”.
Informacje o zespole skopiowałem ze strony A. Reisner’a
[Led Zeppelin site](http://ledzeppelin.alexreisner.com/discography.html).

<blockquote>
 {%= image_tag "/images/led-zeppelin-i.jpg", :alt => "[Led Zeppelin I]" %}
</blockquote>

**Led Zeppelin I** / Released January 12, 1969

1. Good Times Bad Times (Page/Jones/Bonham)
2. Babe I'm Gonna Leave You (Page/Plant/Anne Bredon)
3. You Shook Me (Willie Dixon)
4. Dazed and Confused (Page)
5. Your Time Is Gonna Come (Page/Jones)
6. Black Mountain Side (Page)
7. Communication Breakdown (Page/Jones/Bonham)
8. I Can't Quit You Baby (Willie Dixon)
9. How Many More Times (Page/Jones/Bonham)

<blockquote>
 {%= image_tag "/images/led-zeppelin-ii.jpg", :alt => "[Led Zeppelin II]" %}
</blockquote>

**Led Zeppelin II** / Released October 22, 1969

1. Whole Lotta Love (Page/Plant/Jones/Bonham)
2. What Is and What Should Never Be (Page/Plant)
3. The Lemon Song (Page/Plant/Jones/Bonham)
4. Thank You (Page/Plant)
5. Heartbreaker (Page/Plant/Jones/Bonham)
6. Living Loving Maid (She's Just a Woman) (Page/Plant)
7. Ramble On (Page/Plant)
8. Moby Dick (Page/Jones/Bonham)
9. Bring it on Home (Page/Plant)

<blockquote>
 {%= image_tag "/images/led-zeppelin-iii.jpg", :alt => "[Led Zeppelin III]" %}
</blockquote>

**Led Zeppelin III** / Released October 5, 1970

1. Immigrant Song (Page/Plant)
2. Friends (Page/Plant)
3. Celebration Day (Page/Plant/Jones)
4. Since I've Been Loving You (Page/Plant/Jones)
5. Out On the Tiles (Page/Plant/Bonham)
6. Gallows Pole (Traditional)
7. Tangerine (Page)
8. That's the Way (Page)
9. Bron-Y-Aur Stomp (Page/Plant/Jones)
10. Hats Off to (Roy) Harper (Traditional)

Zaczynamy od utworzenia bazy:

    :::bash
    curl -X PUT localhost:5984/lz/

**Uwagi:**

1. Przykładowy numer portu *5984* należy zmienić na taki jaki mamy
  ustawiony w swojej konfiguracji CouchDB.
2. W poniższych przykładach, zamiast fikcyjnego numeru rewizji
   **?-XXXX** należy wstawić aktualny numer rewizji dokumentu.


## CRUD na dokumentach

* [Replication and conflict model](http://wiki.apache.org/couchdb/Replication_and_conflicts)
  – do czego służą rewizje

Dodajemy dane pierwszego albumu:

    :::bash
    curl -X PUT localhost:5984/lz/led-zeppelin-i \
      --data '{"title":"Led Zeppelin I","released":"1969-01-12","tracks":["Good Times Bad Times","..."]}'
    {"ok":true,"id":"led-zeppelin-i","rev":"1-XXXX"}

CouchDB umożliwia zpisywanie w bazie nie tylko dokumentów w formacie JSON.
W bazie możemy zapisać dane binarne, na przykład obrazki, filmy;
możemy też zapisać pliki html, xml. W terminologii CouchDB mówimy
o dodaniu ** *załącznika* ** (ang. *attachment*) do dokumentu.

Dodajemy **załącznik** – obrazek *led-zeppelin-i.jpg* – do dokumentu *led-zeppelin-i*:

    :::bash
    curl -X PUT localhost:5984/lz/led-zeppelin-i/cover.jpg?rev=1-XXXX \
       -H "Content-Type: image/jpg" --data-binary @led-zeppelin-i.jpg
    {"ok":true,"id":"led-zeppelin-i","rev":"2-XXXX"}

Obrazek, dopiero co zapisany w bazie, pobieramy korzystając z takiego uri:

    :::bash
    curl -X GET localhost:5984/lz/led-zeppelin-i/cover.jpg

Uwagi:

1\. **Załączniki nie są serwowane jako obiekty JSON**.
Są serwowane **as is** z nagłówkiem *Content-Type* podanym
przy zapisywaniu załącznika w bazie.

2\. Zamiast podawać swój
[UUID](http://en.wikipedia.org/wiki/Universally_Unique_Identifier),
możemy skorzystać z funkcji *use UUID generated document ID*
(co oznacza, że skorzystamy z *POST* zamiast *PUT*):

    :::bash
    curl -X POST localhost:5984/lz  -H "Content-Type: application/json" \
      --data '{"title":"Houses Of The Holy","released":"March 28, 1973"}'
    {"ok":true,"id":"076c85dcf037c293f237c44eac0000a8","rev":"1-XXXX"}

Wtedy CouchDB wygeneruje unikalny identityfikator dla dokumentu
zapisywanego w bazie (powyżej *"076c85dcf037c293f237c44eac0000a8"*).


## Jak wygodnie dodawać dokumenty do bazy?

Dodawanie pojedynczo rekordów do bazy jest męczące.
[HTTP Bulk Document API](http://wiki.apache.org/couchdb/HTTP_Bulk_Document_API)
ułatwia wprowadzanie (usuwanie, uaktualnianie – też) naraz wielu rekordów:

    :::bash
    curl -X POST -H "Content-Type: application/json" --data @lz.json localhost:5984/lz/_bulk_docs

gdzie w pliku *lz.json* wpisujemy:

    :::javascript lz.json
    {"docs": [
        {
          "_id": "led-zeppelin-i",
          "type": "album",
          "title": "Led Zeppelin I",
          "released":"1969-01-12",
          "artist": "Led Zeppelin",
          "tracks" : [
             "Good Times Bad Times",
             "Babe I'm Gonna Leave You",
             "You Shook Me",
             "Dazed and Confused",
             "Your Time Is Gonna Come",
             "Black Mountain Side",
             "Communication Breakdown",
             "I Can't Quit You Baby",
             "How Many More Times"
           ]
        },
        {
          "_id": "led-zeppelin-ii",
          "type": "album",
          "title": "Led Zeppelin II",
          "released": "1969-10-22",
          "artist": "Led Zeppelin",
          "tracks" : [
             "Whole Lotta Love",
             "What Is and What Should Never Be",
             "The Lemon Song",
             "Thank You","Heartbreaker",
             "Living Loving Maid (She's Just a Woman)",
             "Ramble On",
             "Moby Dick",
             "Bring It On Home"
          ]
        },
        {
          "_id": "led-zeppelin-iii",
          "type": "album",
          "title": "Led Zeppelin III",
          "released": "1970-10-05",
          "artist": "Led Zeppelin",
          "tracks" : [
             "Immigrant Song",
             "Friends",
             "Celebration Day",
             "Since I've Been Loving You",
             "Out on the Tiles",
             "Gallows Pole",
             "Tangerine",
             "That's the Way",
             "Bron-Y-Aur Stomp",
             "Hats Off to (Roy) Harper"
          ]
        }
    ]}

Obrazki do dokumentów dodamy ręcznie, w Futonie. Niestety.
Zanim dodamy *załącznik* do dokumentu musimy znać jego rewizję.
Dlatego, aby uaktualnić zawartość dokumentu, konieczne są
dwa wywołania programu *curl*:

1. pobieramy dokument i zapamiętujemy jego rewizję
2. uaktualniamy zawartość dokumentu o zapamiętanej rewizji


## _all_docs – pobieramy info z rewizjami

Aby dodać okładki do dokumentów w bazie będziemy potrzebować wartości *rev*:

    :::bash
    curl -X GET localhost:5984/lz/_all_docs
      {"total_rows":3, "offset":0,
       "rows":[
         {"id":"led-zeppelin-i",  "key":"led-zeppelin-i",  "value":{"rev":"1-ab9b..."}},
         {"id":"led-zeppelin-ii", "key":"led-zeppelin-ii", "value":{"rev":"1-f27a..."}},
         {"id":"led-zeppelin-iii","key":"led-zeppelin-iii","value":{"rev":"1-3cfe..."}}
      ]}

Do dosania okładek wystarczą wypisane powyżej rewizje.

Ale, gdyby były potrzebne całe dokumenty, to możemy je pobrać tak:

    :::bash
    curl -X GET localhost:5984/lz/_all_docs?include_docs=true
      {"total_rows":3, "offset":0,
       "rows":[
         {"id":"led-zeppelin-i",  "key":"led-zeppelin-i",  "value":{"rev":"4-b6b2..."},
          "doc": {
            "_id":"led-zeppelin-i",
            "_rev":"4-b6b2",
            "title":"Led Zeppelin I",
            "released":"January 12, 1969",
            "songs":["Good Times Bad Times", ...],
            "_attachments": {
              "index.html":{"content_type":"text/html","revpos":9,"length":152,"stub":true}, ...
      ...

**Uwaga:** powyższe URI możemy wpisywać bezpośrednio w przeglądarce.


## Wersjonowanie dokumentów: update ≡ replace ?

Uaktualniamy, ale naprawdę zamieniamy zawartość dokumentu „Houses of The Holy”:

    :::bash
    curl -X PUT localhost:5984/lz/076c... \
       --data '{"_rev":"1-XXXX","songs":["The Song Remains The Same"]}'

Załącznik dodajemy w taki sposób (korzystamy z rewizji wypisanych powyżej):

    :::bash
    curl -X PUT localhost:5984/lz/led-zeppelin-i/led-zeppelin-i.jpg?rev=4-XXXX \
       -H "Content-Type: image/jpg" --data-binary @led-zeppelin-i.jpg

Dodajemy okładki do albumu II oraz III:

    :::bash
    curl -X PUT localhost:5984/lz/led-zeppelin-ii/led-zeppelin-ii.jpg?rev=1-XXXX \
       -H "Content-Type: image/jpg" --data-binary @led-zeppelin-ii.jpg
    curl -X PUT localhost:5984/lz/led-zeppelin-iii/led-zeppelin-iii.jpg?rev=1-XXXX \
       -H "Content-Type: image/jpg" --data-binary @led-zeppelin-iii.jpg

Takie dodawanie załączników nie jest to wygodne.
(Ale drivery do baz danych jakoś ten niewygodny problem rozwiązują.)


### Delete

Aby usunąć dokument z „led-zeppelin-i” z bazy wystarczy wykonać polecenie:

    :::bash
    curl -X DELETE localhost:5984/lz/led-zeppelin-i?rev=2-XXXX


### Get

Pobieranie dokumentu też jest proste:

    :::bash
    curl -X GET localhost:5984/lz/led-zeppelin-i


### Copy

Z kopiowaniem dokumentów też nie ma problemu:

    :::bash
    curl -X COPY localhost:5984/lz/led-zeppelin-i -H "Destination: mothership"

Czy można użyć kopiowania do czegoś sensownego?


# Dziwny przykład

Dodamy do dokumentu plik html jak załącznik do dokumentu *led-zeppelin-i*:

    :::html i.html
    <!doctype html>
    <meta charset="utf-8" />
    <title>Led Zeppelin I</title>
    <h1>Led Zeppelin I</h1>
    <p>
      <img src="/lz/led-zeppelin-i/led-zeppelin-i.jpg" alt="cover">
    </p>

za pomocą polecenia:

    :::bash
    curl -X PUT localhost:5984/lz/led-zeppelin-i/index.html?rev=2-XXXX \
      -H "Content-Type: text/html" --data @i.html

i po wpisaniu w przeglądarce:

    http://localhost:5984/lz/led-zeppelin-i/index.html

widzimy stronę z obrazkiem. Dziwne, nieprawdaż.


# Pokrętny przykład

Do dokumentu *led-zeppelin-ii* dodamy załącznik *ii.html*:

    :::html ii.html
    <!doctype html>
    <meta charset="utf-8" />
    <title>Led Zeppelin II</title>

    <script src="http://code.jquery.com/jquery-1.7.2.js"></script>
    <script>
    $(function() {
      var ul = $('#songs');
      $.getJSON('/lz/led-zeppelin-ii', function(data) {
        /* a bit of debugging */
        console.log(ul);
        console.log(data);
        $.each(data.tracks, function(i,e) { ul.append('<li>'+e+'</li>') });
      });
    });
    </script>

    <h1>Led Zeppelin II</h1>
    <p>
      <img src="/lz/led-zeppelin-ii/led-zeppelin-ii.jpg" alt="cover">
    </p>
    <ul id="songs"></ul>

Jak zwykle, skorzystamy z programu *curl*:

    :::bash
    curl -X PUT localhost:5984/lz/led-zeppelin-ii/index.html?rev=8-XXXX \
      -H "Content-Type: text/html" --data @ii.html

Teraz po wejściu na stronę:

    http://localhost:5984/lz/led-zeppelin-ii/index.html

mamy pod okładką listę utworów. To jest naprawdę pokrętne!

Obie strony HTML powyżej mają podobną zawartość.
Stąd pytanie: Czy można przygotować
jedną stronę (albo, w zasadzie drugie pytanie, szablon strony)
dla wszystkich trzech albumów?

Odpowiedź jest TAK. I można to zrobić na kilka sposobów.


## Co to jest CORS

* [Cross-origin resource sharing](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing).
* [Enable Cross-Origin Resource Sharing](http://enable-cors.org/)


[couchdb]: http://books.couchdb.org/relax/ "CouchDB: The Definitive Guide"
