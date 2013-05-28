## CouchDB

Widok *test/wc*.

Funkcja map:

```js
function(doc) {
  res = doc.p.match(/[\w\u00C0-\u017F\-,.?!;:'"]+/g);
  if (res) {
    res.forEach(function(word) {
      emit(word, 1);
    });
  }
};
```

Funkcja reduce:

```js
_count
```

Widok *app/markov*.

Funkcja map.

```js
function(doc) {
  words = doc.p.match(/[\w\u00C0-\u017F\-,.?!;:'"]+/g);
  words.unshift("★", "★");
  words.push("◀");
  for (var i = 3, len = words.length; i <= len; i++) {
    emit(words.slice(i-3,i), 1);
  }
};
```

Funkcja reduce.

```js
_count
```

Odpytywanie widoku *app/markov*:

```sh
http://localhost:5984/wb/_design/app/_view/markov  #! {"key":null, "value":407268}
http://localhost:5984/wb/_design/app/_view/markov?reduce=false&limit=16

http://localhost:5984/wb/_design/app/_view/markov?group_level=1&limit=32
http://localhost:5984/wb/_design/app/_view/markov?group_level=2&limit=32
http://localhost:5984/wb/_design/app/_view/markov?group_level=3&limit=32

http://localhost:5984/wb/_design/app/_view/markov?group_level=3&startkey=["zza"]&limit=32

http://localhost:5984/wb/_design/app/_view/markov?startkey=["★"]&group_level=2&limit=32
http://localhost:5984/wb/_design/app/_view/markov?startkey=["★","★"]&group_level=3&limit=128

# użyte w skrypcie poniżej
http://localhost:5984/wb/_design/app/_view/markov?startkey=["★","★"]&endkey=["★","★",{}]&group_level=3

```

## Generate random paragraph

```ruby
#! /usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'bundler/setup'
require 'couchrest' # v1.2.0

couch = CouchRest.new("http://localhost:5984")
DB = couch.database('wb')

WORD_MEMOIZER = {}

def probable_follower_for(start)
  WORD_MEMOIZER[start] ||= DB.view('app/markov', startkey: start, :endkey=>[start, {}].flatten, :group_level=>3)
  row = WORD_MEMOIZER[start]['rows'].sample # get random row (Ruby v1.9.2+)
  return row['key'][1,2]
end

bigram = ["★", "★"]
while true
  bigram = probable_follower_for(bigram)
  if bigram[1] == "◀"
    break
  else
    print "#{bigram[1]} "
  end
end
```

## Unicode Tables

* [Unicode Table](http://www.tamasoft.co.jp/en/general-info/unicode.html)
* U+2605 (★), U+25C0 (◀); see [Miscellaneous Symbols](http://www.unicode.org/charts/PDF/U2600.pdf)
