#### {% title "NodeJS i NPM" %}

<blockquote>
 {%= image_tag "/images/oil-paint.jpg", :alt => "[oil paint]" %}
 <p>
   Keep in mind that it is also very easy to hold a paintbrush in
   your hand, and swirl oil based paint on a canvas. Unfortunately,
   Rembrandts and Degas only come around every once in a while. The
   mechanics of software development are easy to learn, but incredibly
   difficult to master.
 </p>
 <p class="author">— Steve Brownlee</p>
</blockquote>

Na dobry początek kilka odsyłaczy:

* [The Node Beginner Book](http://www.nodebeginner.org/)
* [Node.js](http://nodejs.org/)
* NPM – [Node Package Manager](http://npmjs.org/)
* [docs.nodejitsu.com](http://docs.nodejitsu.com/) –
  assembled collection of node.js how-to articles


## Instalacja

Instalujemy NodeJS:

    :::bash
    git clone git://github.com/joyent/node.git
    cd node
    git tag
      ...
      v0.6.9  # = major.minor.patch
      ...
      v0.7.1

Wybieramy ostatnią stabilną wersję (parzysty numer ‚minor’):

    :::bash
    git checkout v0.6.9
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
      v0.6.9


## Instalacja NPM

Teraz kolej na instalację narzędzia [NPM](http://npmjs.org/)
– a package manager for node:

    curl http://npmjs.org/install.sh | sh
      ...
      Napisany przez John Gilmore i Jay Fenlason
      install npm@1.1
      fetching: http://registry.npmjs.org/npm/-/npm-1.1.0-3.tgz
      0.6.9
      1.1.0-3
      cleanup prefix=/home/wbzyl/.node
      ~/.node/bin/npm -> /home/wbzyl/.node/lib/node_modules/npm/bin/npm-cli.js
      npm@1.1.0-3 /home/wbzyl/.node/lib/node_modules/npm
      It worked


## Moduły NodeJS

Trzy przykładowe instalacje:

* CoffeeScript
* CouchApp
* Kanso

Użyteczne moduły:

* [Cradle](https://github.com/cloudhead/cradle) – a high-level CouchDB client for NodeJS
* [EJS](https://github.com/visionmedia/ejs) – embedded JavaScript templates for node;
  Express compliant
* [Express](https://github.com/visionmedia/express) – Sinatra inspired web development
  framework for NodeJS; insanely fast, flexible, and simple

Przykładowa aplikacja [Express & Google Maps](https://github.com/wbzyl/example_geohash_to_location)
(fork repo [Micka Thompsona](https://github.com/dthompson/example_geohash_to_location)).


### CoffeScript

Instalujemy globalnie ostatnią stabilną wersję:

    :::bash
    npm install -g coffee-script
      /home/wbzyl/.node/bin/coffee -> /home/wbzyl/.node/lib/node_modules/coffee-script/bin/coffee
      /home/wbzyl/.node/bin/cake -> /home/wbzyl/.node/lib/node_modules/coffee-script/bin/cake
      coffee-script@1.2.0 /home/wbzyl/.node/lib/node_modules/coffee-script

Powyżej zostały wypisane ścieżki do zainstalowanych bibliotek.
Musimy je dodpisać do *NODE_PATH*:

    :::bash ~/.bash_profile
    export NODE_PATH=$HOME/.node/lib/node_modules

Sprawdzamy czy coś poszło nie tak:

    :::bash
    coffee --version

Pozostałe jeszcze jedna rzecz do zrobienia. Biblioteki NodeJS
instalowane przez NPM muszą być w *NODE_PATH*.
Sprawdzamy gdzie NPM instaluje biblioteki:

    npm ls -g
      ~/.node/lib
      ├── coffee-script@1.2.0
      └─┬ npm@1.1.0-3
        ├── ...

Ponownie się przelogowujemy i sprawdzamy czy wszystko jest OK.
Uruchamiamy *node* REPL (*read-eval-print loop* – pętla
wczytaj-wykonaj-wypisz), gdzie wpisujemy:

    require('coffee-script')

Powiniśmy zobaczyć coś takiego:

      { VERSION: '1.2.0',
        RESERVED:
         [ 'case',
           ...

**Staying on the Bleeding Edge**:

    git clone http://github.com/jashkenas/coffee-script.git
    cd coffee-script
    npm link

Powyżej instalujemy CoffeeScript z gałęzi *master*.
Aby wrócić do wersji, na przykład 1.2.0, wykonujemy:

    npm install -g coffee-script@1.2.0

Usuwamy moduł, tak:

    npm rm -g coffee-script


### Couchapp

Użyjemy wyszukiwarki programu *npm*:

    npm search couchapp
      couchapp   Utilities for building CouchDB applications.   =mikeal
      ...

Wybieramy moduł *couchapp* i instalujemy go *globalnie* (dlaczego?):

    npm install -g couchapp
      /home/wbzyl/.node/bin/couchapp -> /home/wbzyl/.node/lib/node_modules/couchapp/bin.js
      watch@0.5.0 /home/wbzyl/.node/lib/node_modules/couchapp/node_modules/watch
      request@2.9.100 /home/wbzyl/.node/lib/node_modules/couchapp/node_modules/request
      couchapp@0.9.0 /home/wbzyl/.node/lib/node_modules/couchapp

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
      kanso  The surprisingly simple way to write CouchApps
      kanso-utils  NPM package which provides some common utility functions used by build-steps in Kanso packages

Instalujemy oba pakiety **globalnie**:

    npm install -g kanso
    npm install -g kanso-utils

Sprawdzamy, instalację. Po wywołaniu:

    kanso

powinniśmy zobaczyć coś takiego:

    Usage: kanso COMMAND [ARGS]

    Available commands:
      help           Show help specific to a command
      push           Load a project and push to a CouchDB database
      upload         Upload a file or directory of JSON files to DB
      show           Load a project and output resulting JSON
      createdb       Create a new CouchDB database
      deletedb       Delete a CouchDB database
      listdb         List databases on a CouchDB instance
      replicate      Exchange data between databases
      transform      Performs tranformations on JSON files
      uuids          Returns UUIDs generated by a CouchDB instance
      pack           Pack a package into a .tar.gz file
      publish        Publish a package to a repository
      unpublish      Remove a published package from a repository
      install        Installs a package and its dependencies
      clear-cache    Removes packages from the local cache
      ls             Builds a project and reports a list of its exports


## Różności

* [Nodejitsu Docs](http://docs.nodejitsu.com/)
* [Node.js community wiki](https://github.com/ry/node/wiki)
* [Node.js Tutorial Roundup](http://blogfreakz.com/node/node-js-tutorial-roundup/)
