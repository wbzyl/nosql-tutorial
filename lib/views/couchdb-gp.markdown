#### {% title "Generator przemówień" %}

<blockquote>
 <p>
  To ease the strain on our keyboards Mozilla recently introduced
  a handy forEach method for arrays: <i>array.forEach(print);</i>
 </p>
 <p class="author"><a href="https://developer.mozilla.org/en-US/">[MDC]</a></p>
</blockquote>

Widok *markow*:

    :::javascript markov.js
    var couchapp = require('couchapp');
    ddoc = {
        _id: '_design/wc'
      , views: {}
    }
    module.exports = ddoc;

    ddoc.views.markov = {
      map: function(doc) {
          var words = doc.text.toLowerCase().
            split(/\W+/).
            filter(function(w) {
              return w.length > 0;
            });

          words.forEach(function(word, i) {
            if (words.slice(i, 4+i).length > 3) {
              emit(words.slice(i, 4+i), null);
            };
          });
      },
      reduce: "_count"
    }

Skrypt *markov.rb* (tylko dla ruby 1.9.2+):


    :::ruby markov.rb
    #!/usr/bin/env ruby

    require 'couchrest'

    couch = CouchRest.new("http://localhost:5984")
    DB = couch.database('gutenberg')
    WORD_MEMOIZER = {}

    def probable_follower_for(word)
      WORD_MEMOIZER[word] ||= DB.view('wc/markov', :startkey=>[word,nil], :endkey=>[word,{}], :group_level=>2)
      row =  @word_memoizer[word]['rows'].sample # get random row (ruby 1.9.2)
      row['key'][1]
    end

    word = ARGV[0]

    max_words = 44
    counter = 0
    while word && counter < max_words
      print word, " "
      word = probable_follower_for(word)
      counter += 1
    end
    print "\n"

O co chodzi?

    curl http://localhost:5984/gutenberg/_design/wc/_view/markov?startkey=["young",null]&["young",{}]&group_level=2
      {"rows":[
      {"key":["young","a"],"value":3},
      {"key":["young","accept"],"value":1},
      {"key":["young","adair"],"value":4},
      {"key":["young","aide"],"value":1},
      {"key":["young","alec"],"value":2},
      ...

**Uwaga:** Jak będzie działał progrma jeśli zmienimy powyżej:

    group_level=3

a jak dla:

    group_level=4


Program uruchamiamy z wiersza poleceń, dla przykładu:

    ./markov.rb young
    ./markov.rb young
    ./markov.rb words
    ./markov.rb words
