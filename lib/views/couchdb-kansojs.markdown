#### {% title "KansoJS framework" %}

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

Cytat ze strony projektu o [KansoJS](http://kansojs.org/):

* the surprisingly simple way to write CouchApps
* flexible - a lightweight CommonJS environment
* reduces code fragmentation - by bringing the client-side and server-side together
* automatic history support - adds pushState and hash-based URLs automatically
* searchable and degradable - easily add Google-indexable pages and support clients without JavaScript
* familiar - all this can be done by using the CouchDB design doc APIs

Na stronie projektu znajdziemy też informacje jak zinstalować KansoJS.


## Aplikacja „Rock Bands of the 70s”

Informacje o dyskografiach zespołów pochodzą z:

* [Led Zeppelin discography](http://en.wikipedia.org/wiki/Led_Zeppelin_discography)
* [Deep Purple discography](http://en.wikipedia.org/wiki/Deep_Purple_discography)

Zaczynamy od utworzenia rusztowania aplikacji:

    kanso create Rock_Bands_of_the_70s

Sprawdzamy co zostało wygenerowane:

    tree Rock_Bands_of_the_70s
    |-- kanso.json
    |-- lib
    |   `-- app.js
    |-- static
    |   |-- jquery-1.4.2.min.js
    |   |-- jquery.history.js
    |   `-- json2.js
    `-- templates
        |-- base.html
        `-- welcome.html

W wygeneroanym pliku *kanso.json* zmieniamy nazwę „design document”
z "Rock_Bands_of_the_70s" na "app":

    :::json
    {
        "name": "app",
        "load": "lib/app",
        "modules": "lib",
        "templates": "templates",
        "attachments": "static"
    }

Statyczne pliki Javascript przenosimy do nowoutworzonego katalogu
*js*. Dodajemy pusty plik *js/application.js* oraz
plik *css/application.css*. Przechodzimy na HTML5.
Po tych zmianach rusztowanie aplikacji wygląda tak:

    |-- kanso.json
    |-- lib
    |   `-- app.js
    |-- static
    |   |-- css
    |   |   `-- application.css
    |   |-- js
    |   |   |-- application.js
    |   |   |-- jquery-1.4.2.min.js
    |   |   |-- jquery.history.js
    |   |   `-- json2.js
    |   `-- mashup.html
    `-- templates
        |-- base.html
        `-- welcome.html

Dopiero po tych zmianach wdrożymy aplikację:

    kanso push http://localhost:4000/rock_bands_70s




## Aplikacja „Todo”

TODO (ojejku zapętliłem się!)
