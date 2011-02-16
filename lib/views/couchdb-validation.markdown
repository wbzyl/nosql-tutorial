#### {% title "Walidacja" %}

Na razie tylko streszczenie zawartości rozdziału
[Validation functions](http://guide.couchdb.org/draft/validation.html)
z ksiązki „CouchDB: The Definitive Guide”.

Tylko administrator serwera CouchDB ma prawo:

* tworzyć nowe i usuwać bazy
* instalować i uaktualniać „design documents”
* konfigurować serwer

Stąd wynika, że **każdy** może dodawać nowe dokumenty do istniejącej
bazy. Możemy to zmienić za pomocą tzw. *validation functions*.

„Validation function” dodajemy do „design document” umieszczając
w polu *validate_doc_update* kod funkcji Javascript.  Wszystkie te
funkcje zostaną wykonane przed zapisaniem dokumentu w bazie.

Funkcje te blokują zapis dokumentu w bazie zgłaszając wyjątek.

Niezalogowanemu użytkownikowi, który próbuje zpisać dokument w bazie,
zgłaszamy taki wyjątek:

    :::javascript
    throw({unauthorized : message});

Ale zalogowanemu użytkownikowi, który będzie chciał zapisać w bazie
nieprawidłowe dane należy zgłosić inny wyjątek:

    :::javascript
    throw({forbidden : message});

Jeśli nie zostanie zgłoszony żaden wyjątek, to dokument
zostaje zapisany w bazie.


## Administratorzy i zwykli użytkownicy

Zakładamy dwa konta. Pierwsze to konto Admina:

    login: wbzyl
    password: sekret

a drugie – zwykłego użytkownika:

    login: wlodek
    password: sekret

Dodawanie nowych adminów: [Creating New Admin Users](http://guide.couchdb.org/draft/security.html#users)
w „CouchDB: The Definitive Guide”.


## Kilka prostych przykładów

**Uwaga:** Aby zapisać w „design document” funkcję walidującą, musimy
się najpierw zalogować jako **admin**.

Pierwsza funkcja walidująca zapisuje w logach wartość argumentu
*userCtx*:

    :::javascript
    function(newDoc, oldDoc, userCtx) {
      log(userCtx);
    }

Podglądając logi, powinniśmy znaleźć mniej więcej coś takiego:

    :::json
    {
      "db": "nosql",
      "name": null,
      "roles": ["_admin"]
    }

gdy jestesmy zalogowani jako admin, albo

    :::json
    {
      "db":"nosql",
      "name":"wlodek",
      "roles":[]
    }

gdy jesteśmy zalogowani jako *wlodek*.

Po tych wyjaśnieniach, łatwo jest napisać drugą funkcję, która
umożliwia zapisywanie dokumentów tylko użytkownikowi zalogowanemu jako
*wlodek*:

    :::javascript
    function(newDoc, oldDoc, userCtx) {
      if('wlodek' != userCtx.name) {
        throw({"forbidden": "Documents may update only Wlodek Bzyl"});
      };
    }


Zobacz też [New Features in Replication](http://blog.couchone.com/post/468392274/whats-new-in-apache-couchdb-0-11-part-three-new).
