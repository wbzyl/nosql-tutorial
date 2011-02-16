#### {% title "Walidacja" %}

Na razie tylko streszczenie zawartości rozdziałów książki
„CouchDB: The Definitive Guide”:

* [Validation functions](http://guide.couchdb.org/draft/validation.html)

Tylko administrator serwera CouchDB ma prawo:

* tworzyć nowe i usuwać bazy
* instalować i uaktualniać „design documents“
* konfigurować serwer

Stąd wynika, że **każdy** może dodawać nowe dokumenty do istniejącej
bazy.

Ograniczamy to prawo korzystając z *validation functions*.

„Validation function” dodajemy do „design document” umieszczając
w polu *validate_doc_update* kod funkcji Javascript.  Wszystkie te
funkcje zostaną wykonane przed zapisaniem dokumentu w bazie.

Funkcje te blokują zapis dokumentu w bazie „throwing errors”.

Jeśli tylko zalogowany użytkownik może dodawać dokumenty,
to wyjątek powinien być taki:

    :::javascript
    throw({unauthorized : message});

ale, jeśli zalogowany użytkownik będzie chciał zapisać nieprawidłowe
dane, to należy:

    :::javascript
    throw({forbidden : message});
