#### {% title "CouchDB – SpiderMonkey" %}

<blockquote>
 {%= image_tag "/images/ateles-belzebuth.jpg", :alt => "[Czepiak belzebub]" %}
 <p>Spider monkey, to czepiak belzebub</p>
</blockquote>

CouchDB korzysta z silnika Javascript o nazwie
[SpiderMonkey](http://www.mozilla.org/js/spidermonkey/):
„SpiderMonkey is the code-name for the Mozilla's C implementation of JavaScript.”

[SpiderMonkey – MDC](https://developer.mozilla.org/en/SpiderMonkey)
zawiera wiele metod wprowadzonych do
[języka Javascript](https://developer.mozilla.org/en/JavaScript)
po ostatnim wydaniu specyfikacji ECMA-262:

* [New in JavaScript 1.6](https://developer.mozilla.org/en/New_in_JavaScript_1.6)
  (Firefox 1.5)
* [New in JavaScript 1.7](https://developer.mozilla.org/en/New_in_JavaScript_1.7)
  (Firefox 2)
* [New in JavaScript 1.8.0](https://developer.mozilla.org/en/New_in_JavaScript_1.8)
  (Firefox 3)
* [New in JavaScript 1.8.1](https://developer.mozilla.org/En/New_in_JavaScript_1.8.1)
  (Firefox 3.5.4)
* [New in JavaScript 1.8.5](https://developer.mozilla.org/En/New_in_JavaScript_1.8.5)
  (Firefox 4)

W wersji 1.8.1 dodano do języka:

* [native JSON](https://developer.mozilla.org/En/Using_native_JSON)

Zobacz też [ECMA 5 Mozilla Features Implemented in V8](https://github.com/joyent/node/wiki/ECMA-5-Mozilla-Features-Implemented-in-V8).

W wersjach wcześniejszych dodano kilka użytecznych metod do klasy Array,
oraz domknięcia wyrażeń (*expression closures*), które uczytelniają kod.

Dlatego ułatwimy sobie programowanie widoków, oraz skryptów
dla aplikacji CouchDB jeśli skompilujemy go z najnowszą
wersją SpiderMonkey.


Aktualnie dostępny jest RC1 SpiderMonkey w wersji 1.8.0,
do pobrania [tutaj](http://ftp.mozilla.org/pub/mozilla.org/js/).

*Pytanie:* Który kod Javascript jest wykonywany przez CouchDB, a który
jest wykonywany w przeglądarce? Na przykład, czy widoki są
wykonywane przez Javascript wbudowany w CouchDB,
czy przez Javascript przeglądarki?


# Javascript 1.8.0

Poniżej przedstawiono krótki przegląd nowych możliwości SpiderMonkey 1.8.0.

**Uwaga do kodu poniżej**: do Javascript 1.7 włącznie, ciało funkcji
ujmujemy w nawiasy klamrowe:

    :::javascript
    function(x) { return x * x; }

Od wersji 1.8.0 dostępny jest wygodny skrót, tzw. *expression closure*:

    :::javascript
    function(x) x * x

Na razie tyle o domknięciach wyrażeń.


## Array

Zaczynamy tutaj:

* [Array Object](https://developer.mozilla.org/en/JavaScript/Guide/Predefined_Core_Objects)
  (*Predefined Core Objects*)

Nowe iteratory:

* `every()` — runs a function on items in the array while that function
  is returning true. It returns true if the function returns true for
  every item it could visit
* `filter()` — runs a function on every item in the array and returns an
  array of all items for which the function returns true
* `forEach()` — runs a function on every item in the array
* `map()` — runs a function on every item in the array and returns the
  results in an array
* `some()` — runs a function on items in the array while that function
  returns false. It returns true if the function returns true for any
  item it could visit
* `reduce(callback[, initialValue])` —
  runs a function on every item in the array
  and collects the results from previous calls
* `reduceRight(callback[, initialValue)]` —
  as reduce, but starts with the last element

Przykład:

    :::javascript
    var a = [10, 20, 30];
    var total = a.reduce(function(acc, elem) acc + elem, 0);
    print(total) //=> 60


## Array and String generics

Cytat:
„Sometimes you would like to apply array methods to strings. By doing
this, you treat a string as an array of characters.”

Dla przykładu, aby sprawdzić, że każdy znak napisu jest jedną z
małych liter alfabetu łacińskiego, kiedyś musielibyśmy napisać:

    :::javascript
    function isLetter(character) {
      return (character >= "a" && character <= "z");
    }
    if (Array.prototype.every.call(str, isLetter))
      print("The string '" + str + "' contains only letters!");

W nowej wersji, zamiast pisać *prototype.every.call* użyjemy skrótu:

    :::javascript
    if (Array.every(str, isLetter))
      print("The string '" + str + "' contains only letters!");

W podobny sposób, możemy stosować metody klasy *String* do dowolnego
obiektu:

    :::javascript
    var num = 16;
    print(String.replace(num, /6/, '2'));


## Working with Array-like objects

Cytat:
„Some JavaScript objects, such as the *NodeList* returned by
*document.getElementsByTagName* or the arguments object made available
within the body of a function, look and behave like arrays on the
surface but do not share all of their methods. The *arguments* object
provides a length attribute but does not implement the *forEach* method,
for example.”

Przykład: napisy nie mają metody *forEach*, a tablice tak.
Nie oznacza to jednak, że nie można użyć tej metody z napisem:

    :::javascript
    Array.forEach("a string", function(chr) print(chr))

I jeszcze kilka przykładów ze strony MDC:

    :::javascript
    var str = 'abcdef';
    var consonantsOnlyStr = Array.filter(str,
        function (c) !(/[aeiouAEIOU]/).test(c)).join('');
    //=> bcdf
    var vowelsPresent = Array.some(str,
        function (c) (/[aeiouAEIOU]/).test(c));
    //=> true
    var allVowels = Array.every(str,
        function (c) (/[aeiouAEIOU]/).test(c));
    //=> false
    var interpolatedZeros = Array.map(str,
        function (c) c+'0').join('');
    //=> a0b0c0d0e0f0
    var numerologicalValue = Array.reduce(str,
        function (c, c2) c+c2.toLowerCase().charCodeAt()-96, 0);
    //=> 21

I jeszcze jeden przykład z obiektem *arguments* dostępnym w kodzie
ciała każdej funkcji. Obiekt ten to lista argumentów wywołania
funkcji. Niestety nie możemy przegladać tej listy za pomocą
*forEach*, ponieważ *arguments* to tylko **array-like** obiekt.

Aby użyć metody *forEach* z *arguments* musimy napisac coś takiego:

    :::javascript
    function f(x,y,z) Array.forEach(arguments, function(arg) print(arg))


## Generatory i iteratory

Ciekawostka(?):
„When developing code that involves an iterative algorithm (such as
iterating over a list, XML nodes, or database results; or repeatedly
performing computations on the same data set), there are often state
variables whose values need to be maintained for the duration of the
computation process. Traditionally, you have to use a callback
function to obtain the intermediate values of an iterative algorithm.”

Przykład generatora:

    :::javascript
    function fib() {
      var i = 0, j = 1;
      while (true) {
        yield i;
        var t = i;
        i = j;
        j += t;
      }
    }
    var g = fib();
    for (var i = 0; i < 10; i++) {
      print(g.next());
    }

Jakieś ciekawe zastosowania?


## Podstawy OO w Javascript

Na początek uwaga: obiekty są przekazywane przez referencje.

    :::javascript
    var o = new Object()  // albo o = {}
    var oRef = o
    o.xxx = true
    o.xxx === oRef.xxx    // true

### Sprawdzanie typów zmiennych

Typ zmiennej możemy sprawdzić za pomocą operatora *typeof*
albo sprawdzając własność *constructor* obiektu:

    :::javascript
    var num = 3.14
    typeof num == 'number'     // true
    num.constructor == Number  // true

<table summary="Sprawdzanie typu zmiennej">
  <caption><em>Sprawdzanie typu zmiennej</caption>
  <thead>
   <tr>
    <th class="span-10">var</th>
    <th class="span-6">typeof var</th>
    <th class="span-6 last">var.constructor</th>
   </tr>
  </thead>

<tbody>
 <tr>
 <td>{ x: 'hello' }</td>
 <td>object</td>
 <td>Object</td>
 </tr>

 <tr>
 <td>[1, 4, 8]</td>
 <td>object</td>
 <td>Array</td>
 </tr>

 <tr>
 <td>function () {}</td>
 <td>function</td>
 <td>Function</td>
 </tr>

 <tr>
 <td>"napis"</td>
 <td>string</td>
 <td>String</td>
 </tr>

 <tr>
 <td>3.14</td>
 <td>number</td>
 <td>Number</td>
 </tr>

 <tr>
 <td>true</td>
 <td>boolean</td>
 <td>Boolean</td>
 </tr>

 <tr>
 <td>/^[a-z]+/</td>
 <td>object</td>
 <td>RegExp</td>
 </tr>

 <tr>
 <td>new Person()</td>
 <td>object</td>
 <td>User</td>
 </tr>
</tbody>
</table>


### Scope, czyli zasięg

*Zasięg* zmiennej to obszar programu, w którym jest zdefiniowana.

JavaScript, w przeciwieństwie do języka C, nie ma zasięgu blokowego.
Za to w JavaScript mamy *zasięg funkcyjny*. Oznacza to, że parametry
funkcji i zmienne zadeklarowane w ciele funkcji nie są widoczne poza
funkcją oraz że zmienne zadeklarowane w funkcji są widoczne w kodzie
całej funkcji. Dla przykładu, taka ciekawostka:

    :::javascript
    var s = 'globalna'
    function f() {
      print(s);          // wypisuje undefined
      var s = 'lokalna'; // tutaj deklarujemy s, ale
                         // s jest zdefiniowana w całej funkcji
      print(s);          // wypisuje 'lokalna'
    }
    f();


### Domknięcia

Za każdym razem, kiedy jest wykonywany kod funkcji
tworzony jest dla niej nowy *kontekst* wykonania.

Przykład pokazujący jak zmienna *m_pi* zyskuje
„drugie życie” poza funkcją anonimową w której
jest zdefiniowana:

    :::javascript
    (function () {
      var m_pi = 3.1415;
      pi = function pi() {
        return m_pi;
      };
      h = 'hello ' + m_pi;
    })();
    h     // 'hello 3.1415'
    pi()  // 3.1415
    m_pi  // ReferenceError: m_pi is not defined

Przykład 1 (źle, nie o to chodziło):

    :::javascript
    var obj = {};
    var t = ['', 'raz', 'dwa', 'trzy']
    for (var i = 1; i < t.length; i++) {
      e = t[i];
      // zmienne e oraz i należą do kontekstu wykonania
      // a nie ich wartości
      obj[e] = function () { print(e + ' == ' + i); }
    }
    // stąd taki rezultat
    obj['raz']()   // trzy == 4
    obj['dwa']()   // trzy == 4
    obj['trzy']()  // trzy == 4

Przykład 2 (dobrze, o to nam chodzi):

    :::javascript
    var obj = {};
    var t = ['', 'raz', 'dwa', 'trzy']
    for (var i = 1; i < t.length; i++) {
      (function (n) {
        var e = t[n];
        obj[e] = function () { print(e + ' == ' + n); }
      })(i);
    }
    obj['raz']()   // raz == 1
    obj['dwa']()   // dwa == 2
    obj['trzy']()  // trzy == 3


### Przełączanie kontekstu

Zdefiniujmy funkcję *setColor*:

    :::javascript
    function setColor(color) { this.color = color; }

oraz dwa obiekty:

    :::javascript
    var white = { color: 'white' }
    var red = { color: 'red' }

Teraz będziemy przełączać kontekst:

    :::javascript
    setColor('green')               // this.color == 'green'
    setColor.call(null, 'blue')     // this.color == 'blue'
    setColor.call(white, 'green')   // white.color == 'green'
    setColor.apply(red, ['green'])  // red.color == 'green'


### Obiekty

Nowy obiekt tworzymy za pomocą literału {}:

    :::javascript
    var obj = {
      value: 3.14,
      display: function () {
        return 'value: ' + this.value;
      }
    }
    obj.value      // 3.14
    obj.display()  // 'value: 3.14'

albo za pomocą funkcji konstruktora:

    :::javascript
    function Person(first_name, last_name) {
      this.first_name = first_name;
      this.last_name = last_name;
    }
    var ja = new Person('włodek', 'bzyl')
    ja.first_name == 'włodek'
    var ty = new ja.constructor('jan', 'nowak')
    ty.first_name == 'jan'

A tak dodajemy metodę publiczną klasy, czyli metodę dostępną dla
każdego obiektu tej klasy, dla przykładu:

    :::javascript
    Person.prototype.who = function () {
      return 'nazywam się ' + this.first_name + ' ' + this.last_name;
    }
    ja.who()  // nazywam się włodek bzyl
    ty.who()  // nazywam się jan nowak


### Dziedziczenie po prototypie

To użycie konwencji — nazwę funkcji konstruktora zaczynamy od
dużej litery — do walki z „a serious design error in the language”.

Oczywiście, jesteśmy z góry skazani na porażkę. Dlatego zwykle
korzystamy z innych opcji. Jakich, zobacz następny rozdział.

Definiujemy funkcję konstruktor *Animal*:

    :::javascript
    function Animal(name) {
      this.name = name;
    }

i dodamy do niej funkcję publiczną:

    :::javascript
    Animal.prototype.who = function () {
      return 'nazywam się ' + this.name;
    }
    var cat = new Animal('bazylek')
    cat.who()  // 'nazywam się bazylek'

Definiujemy klasę *User* i przypisujemy jej
metody publiczne klasy *Animal*:

    :::javascript
    function User(name, password) {
      this.name = name;
      this.password = password;
    }
    User.prototype = new Animal()  // hokus pokus, abrakadabra…

Ostatni wiersz powoduje, że obiekt *User* dziedziczy
wszystkie metody obiektów *Animal*.
Jest to sposób skomplikowany i z samego zapisu trudno jest
się zorientować o co chodzi.

Oto efekty *hokus pokus* powyżej:

    :::javascript
    var u = new User('jan', 'j23')
    u.who()  // nazywam się jan
    u.constructor ==  Animal              // true
    User.prototype.constructor == Animal  // true

Powyższy kod można uprościć wprowadzając funkcję *beget*
(D. Crockford. „JavaScript: The Good Parts”, p. 22):

    :::javascript
    if (typeof Object.beget !== 'function') {
      Object.beget = function (o) {
        var F = function () {};
        F.prototype = o;
        return new F();
      }
    };

Z metodą *beget* kod wygląda tak:

    :::javascript
    var a = { name: 'bazylek' }
    var u = Object.beget(a)
    a.name == 'bazylek'
    u.name == 'bazylek'
    u.name = 'włodek'
    a.who = function () { return 'nazywam się ' + this.name; }
    a.who()  // 'nazywam się bazylek'
    u.who()  // 'nazywam się włodek'

Teraz cytat z książki D. Crockforda: „JavaScript: The Good Parts”, p. 49:
„The pseudoclassical form can provide comfort to programmers
who are unfamiliar with JavsScript, but also hides the true nature of the
language. The claaaically inspired notation can induce programmers
to compose hierarchies taht are unnecessarily deep and complicated.
**Much of the complexity of class hierarchies is motivated by the
constraints of static type checking.** JavaScript is completely free
of those constraints. **In classical languages, class inheritance is the
only form of code reuse.** JavaScript has more and better options.”

Przypatrzmy się tym lepszym opcjom.


### Differential inheritance

Kodujemy tylko różnice między dwoma obiektami:

    :::javascript
    var cat = {
      name: 'bazylek',
      who: function () {
        return 'nazywam się ' + this.name;
      }
    }
    var user = Object.beget(cat)
    user.name = 'włodek'
    user.who()  // 'nazywam się włodek'


### Functional inheritance

Dziedziczenie funkcjonalne (op. cit, p. 52, uproszczona wersja):

    :::javascript
    var constructor = function(spec) {
      var that, pozostałe zmienne prywatne obiektu
      that = {}
      ... dodajemy funkcje do that
      return that;
    }

Ze względów bezpieczeństwa, do zmiennej *that* funkcję przypisujemy
w dwóch krokach, tak:

    :::javascript
    var oblicz = function () { ... }
    that.oblicz = oblicz;

Najwyższa pora na przykład:

    :::javascript
    var animal = function(spec) {
      var that = {},
          name = spec.name;
      var who =  function () {
        return 'nazywam się ' + name;
      };
      that.who = who;
      return that;
    };
    var person = animal({name: 'włodek'})
    person.who()  // 'nazywam się włodek'

Do dziedziczenia funkcjonalnego można doprogramować metodę **super**.
Nazwiemy ją *superior*.

Zaczniemy od napisania funkcji *method*, ułatwiającej dodawanie nowych
funkcji do typów. Dla przykładu, będziemy mogli wykorzystać tę
(jeszcze nienapisaną) metodę do dodania metody *trim* do typu *String*:

    :::javascript
    String.method('trim', function () {
      return this.replace(/^\s+|\s+$/g, '');
    });
    ' ala ma kota  '.trim()  // 'ala ma kota'

Aby metoda *method* była dostepna dla wszystkich funkcji (np. String
powyżej, op. cit, p. 33) wystarczy ją dodać do *Function.prototype*:

    :::javascript
    Function.prototype.method = function (name, func) {
      if (!this.prototype[name]) {
        this.prototype[name] = func;
      };
      // return this;
    }

**Uwaga:** `return this` powyżej chyba jest (nie)zbędne, op. cit,
p. 31: If the function was invoked with the **new** and the **return**
value is not an object, then **this** (the new object) is returned
instead.

Metoda *superior* wywołuje oryginalną metodę obiektu po
którym dziedziczymy (op. cit, p. 54):

    :::javascript
    Object.method('superior', function (name) {
      var that = this,
          method = that[name];
      return function () {
        return method.apply(that, arguments);
      };
    });

Działa to tak:

    :::javascript
    var feline = function (spec) {
      var that = animal(spec),
          super_who = that.superior('who');
      that.who = function (n) {
        return super_who(n) + ', miau…';
      };
      return that;
    };
    var cat = feline({name: 'simon'})
    cat.who()  // 'nazywam się simon, miau…


### Moduły

Przykład *serial maker*, op. cit. p. 41–42:

    :::javascript
    var serial_maker = function () {
      var prefix = '';
      var seq = 0;
      return  {
        set_prefix: function (p) {
          prefix = String(p);
        },
        set_seq: function (s) {
          seq = s;
        },
        gensym: function () {
          var result = prefix + seq;
          seq += 1;
          return result;
        }
      };
    }
    var seqer = serial_maker();
    seqer.set_prefix('Q');
    seqer.set_seq(1000);
    var unique = seqer.gensym();  // 'Q1000'


# Jak pisano bibliotekę jQuery

Aby zapoznać się technikami użytymi przy implementacji jQuery użyjemy
niektórych z nich do implementacji biblioteki-modułu *jQuote*.

Ale zanim zabiorzemy się za projekt jQuote,
zaimplementujemy metodę *assert*, z której będziemy korzystać
testując kod. Dla przykładu:

    :::javascript
    function jestFajnie() true;
    var lubięProgramować = function() true;
    lubięLatać = function() true;
    assert(jestFajnie() && lubięProgramować() && lubięLatać(),
      "Wszystkie funkcje zwracają true");


## Implementujemy metodę *assert*

Metoda *assert* jest podstawą każdego frameworka dla testów
jednostkowych. Metodę tę zwyczajowo wywołujemy z dwoma argumentami:
*value* i *desc*. Jeśli *value* jest *true*, to test
przechodzi. W przeciwnym wypadku – nie.
W obu wypadkach, do napisu *desc* jest dopisywany rezultat,
zwykle *pass / fail*. Następnie całość jest gdzieś zapisywana,
na przykład do logów bądź na stderr.

Przykładowa implementacja *assert* dla powłoki *js* może wyglądać tak:

    :::javascript
    function assert(value, desc) {
      print(desc + ' :  ' + (value ? "PASS" : "FAIL"));
    }

Po wpisaniu powyższego kodu do pliku *assert.js*, uruchamiamy go tak:

    js -f assert.js -f -

Przykład użycia:

    :::javascript
    assert(true, "Uruchomiono zestaw testów A");
    assert(false, "Fail!");

Funkcja ta jest użyteczna, ale tylko do logowania wyników.
Byłaby użyteczniejsza, gdyby umożliwiała grupowanie pojedynczych
testów.

Następna wersja *assert* umożliwia to:

    :::javascript
    (function () {
      this.assert = function(value, desc) {
        print(desc + ' :  ' + (value ? "PASS" : "FAIL"));
      };
      this.test = function(name, callback) {
        print('\n' + name);
        print('----');
        callback();
      };
    })();

Przykład użycia:

    :::javascript
    test("Uruchomiono zestaw testów B.", function(){
      assert(true, "Pierwsza asercja");
      assert(false, "Drugia asercja" );
      assert(true, "Trzecia asercja");
    });

Ta wersja jest poręczna, ale nie obsługuje testów asynchronicznych, na
przykład żądań Ajax, animacji itp.  Do tego potrzebujemy jakiegoś
frameworka do testowania, na przykład
[QUnit](http://docs.jquery.com/QUnit), który takie rzeczy potrafi.

Aha, można metody *assert* i *test* schować w *namespace*:

    :::javascript
    var unit = new (function () {  ... powyższy kod ... })()
    unit.assert(true, 'Jakaś asercja.')


## jQuote

Biblioteka *jQuote* będzie działać na tablicy o nazwie *dokument*
której elementami są napisy. Do biblioteki dodamy kilka funkcji
o nazwach i funkcjonalności zapożyczonych z jQuery.

Poniżej do zmiennej dokument przypiszemy następującą tablicę:

    :::javascript
    dokument = [
      "A goal without a plan is just a wish. (Antoine de Saint-Exupery)",
      "Everything's got a moral, if only you can find it. (Lewis Carroll)",
      "Failure is success if we learn from it. (Malcolm Forbes)",
      "A clever man commits no minor blunders. (Johann Wolfgang von Goethe)",
      "The dumbest people I know are those who know it all. (Malcolm Forbes)",
      "Great ideas often receive violent opposition from mediocre minds. (Albert Einstein)"
    ];

Na początek będziemy chcieli zasymulować działanie selektora:

    :::javascript
    $([2, 4, 5])

Zwracany obiekt będzie wyglądał tak, jak na poniższym rysunku:

{%= image_tag "/svg/jquote.png", :alt => "[$([2, 4, 5])]" %}

> Wszystkie cytaty za
> [Short Inspirational Quote](http://quotations.about.com/od/shortquotes/a/shortquo2.htm),
> [Short Wise Quote](http://quotations.about.com/od/shortquotes/a/shortquo3.htm),
> [Cute Short Quote](http://quotations.about.com/od/shortquotes/a/shortquo5.htm).

*Uwaga do rysunku:* w języku Javascript tablica to hasz indeksowany
liczbami i z „magiczną własnością” *length* (nie pokazaną na rysunku).
Dlatego, przedstawiono tablicę w postaci prostokąta „z rozsypanymi
cytatami”. Taki prostokąt bardziej przypomina hasz niż tablicę.

Wartością domyślną *this.kontekst* będzie *dokument*.
W obiekcie `$` tak, jak to jest pokazane na rysunku,
umieścimy **pseudo tablicę** indeksów do tablicy *dokument*.


### Kilka zdań o testowaniu

Testy będziemy wpisywać w pliku *tests.js*. W pliku tym wpiszemy też
definicje metod *test* i *assert*. Kod biblioteki będziemy wpisywać
w pliku *jquote.js*.

Do uruchamiania testów wykorzystamy prosty skrypt *run.sh*:

    :::text
    #!/bin/bash
    js -f jquote.js -f tests.js $*


## Pierwszy kod

Zaczynamy od napisania testów:

    :::javascript
    test ("Testowanie aliasów i wersji.", function () {
      assert($ === jQuote, 'Zmienna $ jest aliasem jQuote');
      assert($.fn === jQuote.fn, 'Zmienna $.fn jest aliasem jQuote.fn');
      assert($.fn === jQuote.init.prototype,
         'Zmienna $.fn jest aliasem jQuote.init.prototype');
      assert($.fn.version == '0.0.1', 'aktualna wersja $.fn to 0.0.1');
    });

Oczywiście wykonanie tych testów zakończy się niepowodzeniem:

    ./run.sh

Aby testy przeszły, wystarczy w pliku *jquote.js*
zdefiniować zmienną *dokument* i wpisać poniższy kod:

    :::javascript
    (function () {
      $ = jQuote = function(selektor) {
        return new jQuote.init(selektor);
      };
      jQuote.init = function(selektor) {
      };
      $.fn = jQuote.init.prototype = {
        version: '0.0.1',
      };
    })();

Uruchamiamy ponownie skrypt *run.sh* i przykonujemy się,
że tym razem wszystko jest *PASS*.

Uwagi do powyższego kodu. Wzorując się na bibliotece jQuery dodano:

1. Alias *$* do *jQuote*, oraz alias *jQuote.fn* do
*jQuote.init.prototype*.

2. `$()` zwraca obiekt *new jQuote.init* — bez tego „pośredniczącego”
kodu musielibyśmy pisać: `new $()` zamiast `$()`.

3. Metody publiczne będziemy dodawać do obiektu *jQuote.fn*, czyli do
*jQuote.init.prototype*.

4. *jQuote.fn* to wygodny (i zrozumiały) skrót.


### Kodujemy $(number) i $([number, …])

Zaczynamy od napisania następnego zestawu testów:

    :::javascript
    test ("Testowanie selektora $(2)", function () {
      assert($(2).kontekst === dokument, 'this.kontekst === dokument');
      assert($(2)[0] === 2, '$(2)[0] wskazuje na 2');
      assert($(2).length == 1, '$(2).length równa się 1');
      assert($(2).get(0) === dokument[2], '$(2).get(0) to dokument[2]');
    });
    test ("Testowanie selektora $([1,2,4])", function () {
      assert($([1,2,4])[2] == 4, '$([1,2,4])[2] wskazuje na 4');
      assert($([1,2,4]).length == 3, '$([1,2,4]).length równa się 3');
      assert($([1,2,4]).get(2) === dokument[4],
          '$([1,2,4]).get(2) wskazuje na dokument[4]');
    });

Sprawdzamy, że testy nie przechodzą. Dopiero, po sprawdzeniu że tak
jest naprawdę, piszemy kod.

    :::javascript
    (function() {
      […]
      jQuote.init = function(selektor) {
        var elementy; // indeksy elementów z tablicy kontekst

        if (typeof selektor === 'number') {
          elementy = [selektor];
        } else if (selektor.constructor === Array) {
          elementy = selektor;
        } else {
          throw('jQuote: nieznany typ selektora (tylko liczba lub tablica liczb');
        };

        this.kontekst = dokument;
        addArray(this, elementy);
        return this;
      };
      $.fn = jQuote.init.prototype = {
        version: '0.0.1',
        get: function(i) {
          return this.kontekst[this[i]];
        }
      };

      // prywatna funkcja pomocnicza
      function addArray(self, array) {
        array.unshift(0, array.length);
        Array.prototype.splice.apply(self, array);
      };

     })();

Funkcja prywatna *addArray* dodaje elementy tablicy *elements*
do *jQuote*. Elementy tej tablicy tworzą **pseudo tablicę**
w `$(…)`. Oznacza to, że można do nich się odwoływać za pomocą
`[]` i że obiekt `$(…)` zyskuje nową właściwość *length*.

Uwagi do kodu. Po wykonaniu kodu:

    :::javascript
    var obj = {};
    addArray(obj, ['a','b','c']);

dostajemy obiekt tablico-podobny. Można sprawdzić to w powłoce
Javascript:

    :::javascript
    obj[0];      // 'a'
    obj.length;  // 3

Aby zrozumieć dlaczego to działa, wystarczy przeczytać dokumentację
funkcji *splice(start, deleteCount, item...)* oraz
przerobić taki przykład:

    :::javascript
    var obj = [];
    obj.splice(0, 4, 1, 2, 4, 8);  // t == [1, 2, 4, 8]

Jeśli *obj == {}*, to powyższy kod **oczywiście nie zadziała**.
Dostaniemy taki komunikat o błędzie:

    TypeError: obj.splice is not a function

Jednak dodanie tablicowości do `obj` jest możliwe:

    :::javascript
    Array.prototype.splice.apply(obj, [0, 4].concat([1, 2, 4, 8]));

Po wykonaniu powyższego kodu `obj` zawiera pseudo tablicę
`[1,2,4,8]`.


### Implementujemy *each(callback)*

Dokumentacja za jQuery, zobacz
[jQuery API browser](http://api.jquery.com/each/):

* `each(callback)` — the callback to execute for each matched element

Metoda ta zwraca obiekt *jQuote*.

Przykład użycia:

    :::javascript
    $([2,4]).each(function(element, index) print(element))

Jak zwykle zaczynamy od napisania testów:

    :::javascript
    test ("Testowanie iteratora $([2,4]).each(function () {})", function () {
      var indeksy = [],
         elementy = [];
      $([2,4]).each(function (e, i) {
        elementy.push(e);
        indeksy.push(i);
      });
      assert(indeksy[0] == 2 && indeksy[1] == 4, 'iteracja po kolekcji: indeksy');
      assert(elementy[0].match(/^Failure/) !== null &&
         elementy[1].match(/^The dumbest/) !== null, 'iteracja po kolekcji: elementy');
      assert( $([2,4]).each(function (e,i) { }).each(function (e,i) { }).length == 2,
        'można składać iteracje');
    });

Metoda *each* jest metodą publiczną. Dlatego dodajemy ją
do *jQuote.fn* (czyli *jQuote.init.prototype*).

    :::javascript
    jQuote.init = function(selektor) {
      ...
      $.fn = jQuote.fn = jQuote.init.prototype = {
        jquote: '0.0.1',
        get: function(i) {
          return this[i];
        },
        each: function(callback) {
          for(var i = 0, len = this.length; i < len; i++)
            callback(this.kontekst[this[i]], this[i]);
          return this;
        }
      };
    };


### Implementujemy *text()* i *text(val)*

Tutaj też wzorujemy się na metodach o takich samych nazwach
z biblioteki jQuery (w starszej wersji),
zobacz [jQuery API browser](http://api.jquery.com/browser/):
Manipulation » Changing Contents, albo bezpośredno
[.text()](http://api.jquery.com/text/):

* `text()` — get the contents of the first matched element
* `text(textString)` — set the contents of every matched element

Piszemy testy:

    :::javascript
    test ("Testowanie selektora $().text()", function () {
        assert($(3).text().match(/^A clever man/) !==null, 'selects text');
        assert($([3,4]).text().match(/^A clever man/) !==null, 'selects only the first item');
        $(3).text('[----]');
        assert(dokument[3] == '[----]', 'set dokument[3] to [----]');
        $([1,4]).text('[----]');
        assert(dokument[1] == '[----]' && dokument[4] == '[----]',
          'set dokument[1] and dokument[4] to [----]');
    });

Piszemy kod:

    :::javascript
    jQuote.init = function(selektor) {
      ...
      $.fn = jQuote.fn = jQuote.init.prototype = {
        ...
        text: function() {
          if (arguments.length == 0) {
            return this.get(0);
          } else {
            for(var i = 0, len = this.length; i < len; i++)
              this.kontekst[this[i]] = arguments[0];
            return this;
          };
        }
      };
    };


# Szablony

Szablon J. Resiga z CouchDB. Jak działa?


# QUnit czy jspec gem?

Do testowania kodu potrzebujemy więcej funkcjonalności niż dostarcza
nam *assert*, np. metoda ta nie wystarcza do testowania ajaksa,
timerów itp.

* [QUnit](http://docs.jquery.com/QUnit) — jQuery JavaScript Library
* [How to Test your JavaScript Code with
  QUnit](http://www.tutcity.com/view/how-to-test-your-javascript-code-with-qunit.25544.html)

„It’s used by the jQuery project to test its code and plugins but is
capable of testing any generic JavaScript code (and even capable of
testing JavaScript code on the server-side).”


## Różności

Definiowanie funkcji:

    :::javascript
    function raz () {};                // raz.name === 'raz'
    var dwa = function  () {};         // dwa.name === ''
    var cztery = function trzy () {};  // cztery.name === 'trzy'
    trzy.name  // ReferenceError: trzy is not defined
    raz.toString()  // zwraca kod funkcji; tutaj
    // function raz() {
    // }

Liczba argumentów funkcji:

    :::javascript
    function each(array, callback) {
      for (var i=0, len = array.length; i < len; i++) {
        print(callback.length); // liczba argumentów
      };
    }
    each([2], function(a,b,c) {})  // 3
