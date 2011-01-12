#### {% title "Framework CouchApp" %}

<blockquote>
 {%= image_tag "/images/enterprise-apps.png", :alt => "[Enterprise Apps Architecture]" %}
 <p>Źródło: Ch. Storm.
  <a href="http://justsomejavaguy.blogspot.com/2010/02/enterprise-web-application-architecture.html">Enterprise Web Application Architecture 2.0 and kittens</a></p>
</blockquote>

Czym jest [CouchApp](http://github.com/couchapp/couchapp),
[Simple JavaScript Applications with CouchDB](http://couchapp.org/),
oraz [What the HTTP is CouchApp?](http://couchapp.org/page/what-is-couchapp):
„CouchApp—a set of scripts that allow complete, stand-alone CouchDB
applications to be built using just HTML and JavaScript. These
applications are housed in the CouchDB database, meaning that when the
database is replicated, any applications stored in that database are
also replicated.”

* Damien Katz.
  [Chris demos CouchApps](http://blog.couch.io/post/399191405/screencast-demoing-some-new-couchapp-jquery)
* Chris Storm. [couch_docs](http://github.com/eee-c/couch_docs) —
  provides a mapping between CouchDB documents and the file system

Przykłady aplikacji CouchApp i przykłady kodu:

* Przykłady *in the wild* aplikacji napisanych w CouchApp:
  [Apps](http://wiki.github.com/couchapp/couchapp/apps)
* Chris Strom. [japh(r)](http://japhr.blogspot.com/search?q=couchapp)


## Instalujemy CouchApp

<blockquote>
 {%= image_tag "/images/couchdb-apps.png", :alt => "[CouchDB Apps Architecture]" %}
 <p>Źródło: op. cit.</p>
</blockquote>

CouchApp jest modułem do Pythona.
Program *easy_install* upraszcza instalację modułów.

Program *easy_install* znajdziemy w paczce o nazwie *python-setuptool-devel*
(albo o podobnej nazwie).

W Fedorze instalujemy pakiety za pomocą programu *yum*:

    sudo yum install \
      python-setuptools python-setuptools-devel

Po instalacji paczek, przystępujemy do instalacji *CouchApp*
(i zależnych modułów):

    sudo easy_install couchdb
    sudo easy_install simplejson
    sudo easy_install couchapp

Instalacja lub upgrade do ostatniej wersji *CouchApp*, też jest
prosta:

    sudo easy_install -U couchapp


## Aplikacja *Hello World*

Tworzymy szkielet pierwszej aplikacji CouchApp:

    couchapp generate app hello_world "Hello World"

i przygladamy się temu co zostało wygenerowane:

    hello_world/
    ├── _attachments
    │   ├── index.html
    │   └── style
    │       └── main.css
    ├── couchapp.json
    ├── _id
    ├── lists
    ├── shows
    ├── updates
    ├── vendor
    │   └── couchapp
    │       ├── _attachments
    │       │   └── jquery.couchapp.js
    │       ├── couchapp.js
    │       ├── date.js
    │       ├── metadata.json
    │       ├── path.js
    │       ├── README.md
    │       └── template.js
    └── views

Aplikację *Hello World* wdrażamy tak:

    couchapp -v push hello_world http://wbzyl:sekret@127.0.0.1:5984/hello_world
    [INFO] database hello_world created.
    [INFO] push vendor/couchapp/README.md
    [INFO] push vendor/couchapp/metadata.json
    [INFO] push vendor/couchapp/path.js
    [INFO] push vendor/couchapp/couchapp.js
    [INFO] push vendor/couchapp/template.js
    [INFO] push vendor/couchapp/date.js
    [INFO] attach index.html
    [INFO] attach style/main.css
    [INFO] attach vendor/couchapp/jquery.couchapp.js
    [INFO] Visit your CouchApp here:
    http://127.0.0.1:5984/hello_world/_design/hello_world/index.html

Wchodzimy na wypisany URI, a następnie podpatrujemy w Futonie
jak aplikacja została rozlokowana w bazie.


### Przeglądamy wygenerowane pliki

Plik *index.html* ma znaczniki *script* poza *head* i *body*. Dziwne!

    :::html
    <!doctype html>
    <html>
      <head>
        <title>Generated CouchApp</title>
        <link rel="stylesheet" href="style/main.css" type="text/css">
      </head>
      <body>
        <h1>Generated CouchApp</h1>
        <p>This is a placeholder page</p>
      </body>
      <script src="/_utils/script/json2.js"></script>
      <script src="/_utils/script/jquery.js?1.3.1"></script>
      <script src="/_utils/script/jquery.couch.js?0.9.0"></script>
    </html>

Plik *main.css* zawiera tylko wiersz komentarza.

Zmieniamy co trzeba w pliku *couchapp.json*:

    :::json
    {
        "name": "Witaj świecie",
        "description": "CouchApp"
    }

Najciekawsza jest zawartość pliku
**vendor/couchapp/_attachments/jquery.couchapp.js**:

    :::jquery_javascript
    // Usage: The passed in function is called when the page is ready.
    // CouchApp passes in the app object, which takes care of linking to
    // the proper database, and provides access to the CouchApp helpers.
    $.CouchApp(function(app) {
       app.db.view(...)
       ...
    });

**Uwaga**: *the CouchApp helpers* są definiowane w pliku
[jquery.couch.js](http://127.0.0.1:5984/_utils/script/jquery.couch.js).
Chociaż nazwa tego pliku i pliku *jquery.couchapp.js* wspomnianego powyżej
są **myląco podobne**, to zawartość ich jest zupełnie różna.
Plik dystrybuowany z CouchDB definiuje m.in. następujące
metody pomocnicze:

* *db.view*, *db.query*, *db.info*, *db.drop*, *db.create*
* *db.removeDoc*, *db.saveDoc*, *db.bulkSave*, *db.openDoc*
* *allApps*
* *db.allDesignDocs*

oraz funkcję *$.couch*.

Dla przykładu, implementacja *db.view* wygląda tak:

    :::jquery_javascript
    (function($) {
        $.couch = $.couch || {};
        ...
        db: function(name) {
          return {
            name: name,
            uri: "/" + encodeURIComponent(name) + "/",
            ...
            view: function(name, options) {
              var name = name.split('/');
              var options = options || {};
              var type = "GET";
              var data= null;
              if (options["keys"]) {
                type = "POST";
                var keys = options["keys"];
                delete options["keys"];
                data = toJSON({ "keys": keys });
                console.log(data);
              }
              ajax({
                  type: type,
                  data: data,
                  url: this.uri + "_design/" + name[0] +
                       "/_view/" + name[1] + encodeOptions(options)
                },
                options, "An error occurred accessing the view"
              );
         ...
    })(jQuery);


## Kopiowanie a replikacja aplikacji

Ułatwimy sobie kolejne wdrożenia, tworząc w katalogu głównym aplikacji
plik *.couchapprc* o następującej zawartości:

    :::javascript
    {
      "env": {
        "default": {
          "db": "http://wbzyl:sekret@127.0.0.1:5984/todo"
        },
        "production": {
          "db": "http://wbzyl:secret@sigma.ug.edu.pl:5984/todo"
        }
      }
    }

Teraz aplikację lokalną uaktualniamy wykonując z katalogu
*hello_world* polecenie:

    couchapp push

a aplikację produkcyjną uaktualniamy tak:

    couchapp push production

(Uwaga: plik *.couchapprc* nie jest *pushed*.)

**Bez dokumentów** wdrożoną aplikację kopiujemy tak:

    couchapp clone http://sigma.ug.edu.pl:5984/todo/_design/todo

Po skopiowaniu możemy ją wdrożyć, dla przykładu lokalnie:

    couchapp -v push . http://wbzyl:sekret@127.0.0.1:5984/couchdb-todo

Jeśli chcemy skopiować też **dokumenty**, to *replikujemy* aplikację.

Proces replikacji zaczynamy od utworzenia pustej bazy o nazwie
**local-todo**.  Potem w Futonie klikamy w *Tool ⇒ Replicator*
i wpisujemy:

<pre>Remote database: <b>http://sigma.ug.edu.pl:5984/todo</b>
Local database: <b>local-todo</b>
</pre>

Po chwili, w Futonie w okienku *Event* powinien pojawić się komunikat,
że replikacja zakończyła się sukcesem. Teraz możemy wejść na stronę
zreplikowanej aplikacji:

    http://127.0.0.1:5984/local-todo/_design/todo/index.html


# Aplikacja CouchTodo

Gotowa aplikacja: *lectures/couchdb/couchapp/todo*.

Tworzymy szkielet aplikacji:

    couchapp generate app todo "Couch Todo"

Zmieniamy plik *_attachments/index.html*:

    :::html
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8"/>
        <title>Couch Todo</title>
        <link rel="stylesheet" href="style/main.css" type="text/css">
        <!--[if IE]>
        <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
      </head>
      <body>
        <h1>Couch Todo</h1>
        <p><em>Aplikacja pozwala tworzyć listę zadań i usuwać zakończone zadania.</em></p>
        <form name="add_task" id="add_task">
          <fieldset>
            <legend>Nowe zadanie</legend>
            <textarea id="desc" name="desc"></textarea><br/>
            <input type="submit" id="create" value="OK">
          </fieldset>
        </form>
        <form name="tasks" id="tasks">
          <fieldset>
            <legend>Lista zadań</legend>
            <div id="task_count">Na liście jest <span>0</span> zadań(nie|nia).</div>
            <ul id="my_tasks"></ul>
          </fieldset>
        </form>
        <script src="/_utils/script/json2.js"></script>
        <script src="/_utils/script/jquery.js?1.3.1"></script>
        <script src="/_utils/script/jquery.couch.js?0.9.0"></script>
        <script src="vendor/couchapp/jquery.couchapp.js"></script>
      </body>
    </html>

i wdrażamy aplikację:

    couchapp push . http://127.0.0.1:5984/todo

dodajemy nieco kodu CSS do pliku
{%= link_to "style/main.css", "/doc/couchdb/todo/main.css" %}
i ponownie wdrażamy CouchTodo.

Teraz aplikacja wygląda jak trzeba, ale jeszcze nic jeszcze nie robi.

{%= image_tag("/images/couchtodo-1.png", :alt => "[CouchTodo – wygląd]") %}

Dodamy trochę kodu Javascript. Kod będziemy wpisywać w pliku
*_attachments/script/main.js*. Plik załączymy, dopisując
go w pliku *index.html*, w przedprzedostatnim wierszu:

    :::html
         <script src="script/main.js" charset="utf-8"></script>
      </body>
    </html>


> Returning false from a handler is equivalent to calling both
> .preventDefault() and .stopPropagation() on the event object.

A w pliku *main.js* wpisujemy:

    :::javascript
    $.CouchApp (function(app) {

      $('form#add_task').submit(function(e) {
        e.preventDefault();

        var newTask = {
            desc: $('#desc').val()
        };
        if (newTask.desc.length > 0) {
          // alert(newTask.desc);
          app.db.saveDoc(newTask, { success: function(resp) {
            $('ul#my_tasks').append('<li>' + newTask.desc + '</li>');
            $('ul#my_tasks li:last').hide().fadeIn(1000);
            $('#desc').val('');
            var task_count = parseInt($('#task_count span').html(), 10);
            task_count++;
            $('#task_count span').html(task_count);
          }});
        } else {
          alert('Aby utworzyć nowe zadanie musisz coś wpisać.');
        }

      });

      // w trakcie uruchamiania aplikacji pobierz dane z bazy
      // za pomocą widoku get_tasks
      // jak tworzyć widoki w aplikacjach CouchApp opisano poniżej
      app.view('get_tasks', { success: function(json) {

        json.rows.map(function(row) {
          $('ul#my_tasks').append('<li>' + row.key + '</li>');
        });
        $('#task_count span').html(json.rows.length);

      }});

    });

A tak działa widok *get_tasks* uruchomiony z wiersza poleceń:

    curl http://localhost:5984/todo/_design/todo/_view/get_tasks
    => {
         "total_rows":1, "offset":0,
          "rows":[
            {"id":    "43ab7901f891a9d2f748e1f3038788c3",
             "key":   "dodać przycisk delete",
             "value": null}
          ]
       }

**Ważne:** Przekazywanie *quering options*:

    :::jquery_javascript
    app.view('get_tasks', { descending: true, success: function(json) {

Tak jak to widać powyżej, opcje dopisujemy w drugim argumencie
metody *app.view*.


### Tworzenie widoków w aplikacjach CouchApp

Widok *get_tasks* tworzymy według następującego schematu:

* tworzymy katalog: `mkdir views/get_tasks`
* w katalogu tworzymy plik *map.js*

W pliku tym wpisujemy:

    :::javascript
    function (doc) {
      emit(doc.desc, doc);
    }

*Uwaga:* Dla tego przykładu wystarczyłoby:

    emit(doc.desc, null);

ale ostateczna wersja aplikacji korzysta z wartości *row.value*
dlatego powyżej argument *null* musimy zastąpić *doc*.


### TODO Możliwe udoskonalenia aplikacji

* Dodanie możliwości usuwania dokumentów **zrobione**
* Zamiast usuwania: zaznaczamy że zrobione i dodajemy widok
  dla zakończonych zadań
* Umożliwienie edycji zadań


## TODO Korzystamy z szablonów

Cytat [CouchDB Wiki](http://wiki.apache.org/couchdb/Formatting_with_Show_and_List):

However, there is one important use case that JSON documents don’t
cover: building plain old HTML web pages. […]
Show functions, as they are called, have a constrained API designed to
ensure cacheability and side-effect free operation.

TODO: [Minimal templating with {{mustaches}} in
JavaScript](http://github.com/janl/mustache.js)


### Przykłady aplikacji (większość trudno uruchomić)

* Chris Anderson.
  [Daytime Running Lights](http://jchrisa.net/) – źródło
  [Standalone CouchDB Blog, used by the O'Reilly CouchDB book](http://github.com/jchris/sofa)
* Jason Davies.
  [CouchDB on Wheels](http://www.jasondavies.com/blog/2009/05/08/couchdb-on-wheels/)
* Chris Anderson. [Calendar](http://github.com/jchris/cal)
  ([demo](http://jchrisa.net/cal/_design/cal/index.html))
* Chris Anderson. [A real time CouchDB chat demo](http://github.com/jchris/toast)
* Chris Anderson. [Lightweight realtime task tracking](http://github.com/jchris/taskr)
* Aaron Quint. [Swinger is a couchapp for creating and showing presentations.
  Think Keynote, stored in CouchDB, run via Javascript
  and Sammy.js.](http://github.com/quirkey)
