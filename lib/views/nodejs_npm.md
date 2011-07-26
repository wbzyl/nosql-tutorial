#### {% title "NodeJS i NPM" %}

<blockquote>
 {%= image_tag "/images/hemingway_and_marlins.jpg", :alt => "[Ernest Hemingway and marlins]" %}
 <p>
  Wszystko, co musisz zrobić, to napisać jedno prawdziwe zdanie.
  Napisz najprawdziwsze zdanie, jakie znasz.
 </p>
 <p class="author">— Ernest Hemingway</p>
</blockquote>

Instalujemy NodeJS:

    :::bash
    git clone git://github.com/joyent/node.git
    cd node
    git tag
      ...
      v0.4.10
      ...
      v0.5.2

Wybieramy ostatnią stabilną wersję:

    :::bash
    git checkout v0.4.10
    ./configure --prefix=$HOME/.node
    make && make install
    git checkout master

Pliki binarne zainstalowaliśmy lokalnie w katalogu *$HOME/.node/bin*,
dlatego musimy go dodać do zmiennej *PATH*:

    :::text ~/.bashrc
    export PATH=$HOME/.node/bin:$PATH

Przelogowujemy się, aby wczytać nowe ustawienia
i sprawdzamy co się zainstalowało:

    cd
    node -v
      v0.4.10


## Instalacja NPM

Teraz kolej na instalację narzędzia [NPM](http://npmjs.org/)
– a package manager for node:

    curl http://npmjs.org/install.sh | sh
      ...
      ~/.node/bin/npm -> /home/wbzyl/.node/lib/node_modules/npm/bin/npm.js
      npm@1.0.22 /home/wbzyl/.node/lib/node_modules/npm


## Moduły NodeJS

Trzy przykładowe instalacje:

* CoffeScript
* CouchApp
* Kanso


### CoffeScript

Instalujemy globalnie ostatnią stabilną wersję:

    npm install -g coffee-scrip
      ~/.node/bin/coffee -> ~/.node/lib/node_modules/coffee-script/bin/coffee
      ~/.node/bin/cake -> ~/.node/lib/node_modules/coffee-script/bin/cake
      coffee-script@1.1.1 ~/.node/lib/node_modules/coffee-script

Sprawdzamy czy coś poszło nie tak:

    coffee --version
      CoffeeScript version 1.1.1

Pozostałe jeszcze jedna rzecz do zrobienia. Biblioteki NodeJS
instalowane przez NPM muszą być w *NODE_PATH*.
Sprawdzamy gdzie NPM instaluje biblioteki:

    npm ls -g
      ~/.node/lib
      ├── coffee-script@1.1.1
      └─┬ npm@1.0.22
        ├── ...

Oznacza to, że powinniśmy dodać do *NODE_PATH*:

    :::bash ~/.bash_profile
    export NODE_PATH=$HOME/.node/lib/node_modules

Ponownie się przelogowujemy i sprawdzamy czy wszystko jest OK.
Uruchamiamy *node* REPL (*read-eval-print loop* – pętla
wczytaj-wykonaj-wypisz), gdzie wpisujemy:

    require('coffee-script')

Powiniśmy zobaczyć coś takiego:

      { VERSION: '1.1.1',
        RESERVED:
         [ 'case',
           ...

**Staying on the Bleeding Edge**:

    git clone http://github.com/jashkenas/coffee-script.git
    cd coffee-script
    npm link

Powyżej instalujemy CoffeeScript z gałęzi *master*.
Aby wrócić do wersji, na przykład 1.1.1, wykonujemy:

    npm install -g coffee-script@1.1.1

Usuwamy moduł, tak:

    npm rm -g coffee-script


### Couchapp

Użyjemy wyszukiwarki programu *npm*:

    npm search couchapp
      couchapp   Utilities for building CouchDB applications.   =mikeal
      ...

Wybieramy moduł *couchapp* i instalujemy go *globalnie* (dlaczego?):

    npm install -g couchapp
      ~/.node/bin/couchapp -> ~/.node/lib/node_modules/couchapp/bin.js
      request@2.0.1 ~/.node/lib/node_modules/couchapp/node_modules/request
      watch@0.3.2 ~/.node/lib/node_modules/couchapp/node_modules/watch
      couchapp@0.8.0 ~/.node/lib/node_modules/couchapp

Program *couchapp* został zainstalowany
w katalogu *$HOME/.node/bin/*, który wcześniej umieściliśmy
w *PATH*. Uruchamiamy program:

    couchapp
    couchapp -- utility for creating couchapps
    Usage:
      couchapp <command> app.js http://localhost:5984/dbname
    Commands:
      push   : Push app once to server.
      sync   : Push app then watch local files for changes.
      boiler : Create a boiler project.

Każdy skrypt dla *couchapp* powinien zaczynać się od wiersza:

    :::javascript
    require('couchapp');

Po wpisaniu tego wiersza na konsoli *node*, dostajemy:

    Error: Cannot find module 'couchapp'
    at Function._resolveFilename (module.js:320:11)

Oznacza to, że moduł/biblioteka *couchapp* nie jest w ścieżce
wyszukiwania *NODE_PATH*. Z tego co wypisał *npm* przy instalacji
*couchapp* wynika, że po wykonaniu poniższego polecenia:

    :::bash
    export NODE_PATH=$HOME/.node/lib/node_modules

moduł *couchapp* znajdzie się w ścieżce.


### Kanso

Korzystając z *npm* wyszukujemy Kanso:

    npm search kanso
    kanso  The surprisingly simple way to write CouchApps       =caolan
    ...

Instalujemy *Kanso* **globalnie**:

    npm install -g kanso
      .../.node/bin/kanso -> .../.node/lib/node_modules/kanso/bin/kanso
      mime@1.1.0 .../.node/lib/node_modules/kanso/node_modules/mime
      async@0.1.6 .../.node/lib/node_modules/kanso/node_modules/async
      ...

Sprawdzamy, instalację. Po wywołaniu:

    kanso

powinniśmy zobaczyć coś takiego:

    Usage: kanso COMMAND [ARGS]

    Available commands:
      push         Upload a project to a CouchDB instance
      show         Load a project and output resulting JSON
      create       Create a new project skeleton
      pushdata     Push a file or directory of JSON files to DB
      pushadmin    Upload the kanso admin app to a CouchDB instance
      autopush     Upload a project, then watch files for changes
      uuids        Returns UUIDs generated by a CouchDB instance
      help         Show help specific to a command


## Różności

* [Node.js](http://nodejs.org/)
* [Node.js Manual & Documentation](http://nodejs.org/docs/v0.4.1/api/)
* [Node.js community wiki](https://github.com/ry/node/wiki)
* [Node.js Tutorial Roundup](http://blogfreakz.com/node/node-js-tutorial-roundup/)
