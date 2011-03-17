#### {% title "Generator przemówień i inne zastosowania…" %}

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
      WORD_MEMOIZER[word] ||= DB.view('wc/markov', :startkey=>[word], :endkey=>[word,{}], :group_level=>2)
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

    http://localhost:5984/gutenberg/_design/wc/_view/markov?startkey=["young"]&endkey=["young",{}]&group_level=2
      {"rows":[
      {"key":["young","a"],"value":3},
      {"key":["young","accept"],"value":1},
      {"key":["young","adair"],"value":4},
      {"key":["young","aide"],"value":1},
      {"key":["young","alec"],"value":2},
      ...

**Uwaga:** Jak będzie działał program jeśli zmienimy powyżej *group_level*:

    group_level=3

a jak dla:

    group_level=4


Program uruchamiamy z wiersza poleceń, dla przykładu:

    ./markov.rb young
    ./markov.rb young
    ./markov.rb words
    ./markov.rb words


<blockquote>
 {%= image_tag "/images/peter_norvig.jpg", :alt => "[Peter Norvig]" %}
 <p>
  Current systems are more likely to be built from examples than from
  logical rules. Don’t tell the computer how an expert solved a
  problem. Rather, give it lots of examples of what past problems have
  been like: Give it the features that describe the initial situation, a
  description of the solution used and a score indicating how well the
  solution worked.
 </p>
 <p class="author">– <a href="http://www.nypost.com/p/news/opinion/opedcolumnists/the_machine_age_tM7xPAv4pI4JslK0M1JtxI#ixzz1GsAu6C00">Peter Norvig</a> (Google)</p>
</blockquote>

# Twitter – wizualizacja statusów

[Kontekst](http://stephenslighthouse.com/2011/03/15/twitter-stats/):

Liczba dnia: 572,000 – liczba kont utworzonych 12.03.2011.

Liczba tweets wysyłanych jedengo dnia:

* 50,000,000 – w lutym 2010 roku
* 140,000,000 – w lutym 2011 roku

Co oznacza, że w każdej sekundzie jest wysyłanych około 1620 tweets.

Mnie interesują takie klimaty:

    :::javascript tracking
    track=infochimps,elasticsearch,couchbase,couchdb,\
      mongodb,redis,neo4j,hadoop,cassandra,nodejs,\
      github_js,github_rb,rails

Tweets zawierające jedno z tych słów zbieram korzystając
z [POST statuses/filter](https://dev.twitter.com/doc/post/statuses/filter) API.
Szczegóły są takie:

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K credentials

gdzie plik *credentials* zawiera jedną linijkę:

    user = Login:Password

Moje tweety spływają w tempie około 10 na minutę. W tym samym czasie,
wszystkich wysłanych tweets jest około 100,000 (60*1600=96,000).
Liczby te oznaczają, że interesujące mnie rzeczy może zawierać jeden
tweet na 10,000.

W ciągu jednego dnia moge zebrać w przybliżeniu 15,000 tweets.
W pobranych tweetach będzie też sporo śmieci.
zwłaszcza w tweetach z Cassandrą i Rails.
Pytanie jak je odsiać?

Wydaje się mi, że kilkukrotnie retweeted tweets, mogą być warte
obejrzenia. Po przejrzeniu kilkudziesięciu tweets,
można zaobserwować następujący wzór:

    'bout time! RT @rbates @dhh: Rails 3.1 will ship with jQuery...
    ...a real time chat app" http://t.co/GkzQgwp (via @dalmaer)
    ...Cassandra Wilson - Harvest Moon http://t.co/GguTS9v via @youtube
    Is on the phone with Cassandra - via http://truecaller.com

Powyżej skorzystałem ze wspomagania ze strony takiego widoku tymczasowego:

    :::javascript
    function(doc) {
      if (doc.text.match(/\b(RT|via)\s*@\b/))
        emit(doc.text, null);
    }

Widok ten usuwa ok. 80% tweets. Zostaje 20% retweeded tweets.
Nie jest źle! Na razie zgromadziłem ok. 20 tys. tweets.
Oznacza, to że trzba będzie się bliżej przyjrzeć 4 tys.
z nich.

Ponieważ tweets zajmują już 50 MB, co przekłada się na czas wykonywania
widoków, więc przed dalszymi ekperymentami postanowiłem
je „odchudzić”. Po przyjrzeniu się pojedynczemu tweet,
postanowiłem, że z każdego tweet zostawię tylko:

    _id
    created_at
    entities
    entities
    text
    user.screen_name
    lang

oraz dorzucę tablicę z datą w formacie:

    created_on: [2011, 3, 16, 22, 28, 32]

Do czyszczenia danych oraz wrzucenia oczyszczonych danych do bazy
wykorzystałem następujący skrypt:

    :::ruby massage-tweets.rb
    #!/usr/bin/env ruby
    # -*- coding: utf-8 -*-

    if RUBY_VERSION < "1.9.0"
      require 'rubygems'
    end

    require 'date'
    require 'couchrest'
    require 'pp'

    db = CouchRest.database("http://127.0.0.1:5984/nosql")
    pager = CouchRest::Pager.new(db)

    out = CouchRest.database!("http://127.0.0.1:5984/nosql-slimmed")

    pager.all_docs do |slice|
      chunk = slice.map do |element|
        doc = db.get(element["id"])

        date = DateTime.parse(doc['created_at'])
        created_on =[date.year, date.month, date.day, date.hour, date.minute, date.second]
        {
          "_id" => doc["_id"],
          "text" => doc["text"],
          "entities" => doc["entities"],
          :screen_name => doc["user"]["screen_name"],
          "lang" => doc["user"]["lang"],
          "created_at" => doc["created_at"],
          "created_on" => created_on
        }
      end
      out.bulk_save(chunk)
    end

Teraz możemy się bliżej przyjrzeć tweets. Na początek, dokładniejsze oszacowanie
tweets per hour. Taki widok powinien wystarczyć. Funkcja map:

    function(doc) {
        emit(doc.created_on, null);
    }

oraz wbudowana funkcja reduce *_count*.


Rezultaty z grouping level 4:

    [2011, 3, 17, 20] – 255
    [2011, 3, 17, 19] – 291
    [2011, 3, 17, 18] – 209

Co daje 4–5 tweets na minutę, czyli dwa razy mniej niż pierwsze oszczowanie.
Pozostaje około 2000 tweets do codziennej lektury.

OK. Najwyższa pora aby przyjrzeć się, które tweets są najczęściej cytowane.
W tym celu, z text każdego tweeta wyciągnę, kto jest cytowany

    RT @name
    via @name

i_przez kogo: *user.screen_name*.

Teraz skorzystam z *node.couchapp.js*:

    :::javascript sun.js
    var couchapp = require('couchapp');

    ddoc = {
        _id: '_design/test'
      , views: {}
    }
    module.exports = ddoc;

    ddoc.views.sun = {
      map: function(doc) {
        var retweeted = /\b(via|RT)\s*(@\w+)/ig;
        // w tej wersji tylko pierwsze dopasowanie
        // dodać toLowerCase() na match[2]
        var match = retweeted.exec(doc.text);
        if (match != null) {
          emit([match[2], doc.screen_name], doc.text);
        };
      },
      reduce: "_count"
    }

Wrzucamy widok do bazy:

    couchapp push sun.js http://localhost:5984/nosql-slimmed

Uruchamiamy widok w Futonie. Dostajęmy ok. 3800 wyników.
Zgodnie z oczekiwaniem.

Sprawdzam, kilka wyników. Tego gościa znam **@tenderlove**:

Przeglądarka:

    http://localhost:5984/nosql-slimmed/_design/test/_view/sun?startkey=["@tenderlove"]&endkey=["@tenderlove",{}]&reduce=false

Wiersz poleceń:

   curl 'http://localhost:5984/nosql-slimmed/_design/test/_view/sun?startkey=\[%22@tenderlove%22\]&endkey=\[%22@tenderlove%22,\{\}\]&reduce=false'
   curl 'http://localhost:5984/nosql-slimmed/_design/test/_view/sun?startkey=\["@tenderlove"\]&endkey=\["@tenderlove",\{\}\]&reduce=false'

Ciekawe! Tokyo:

    RT @tenderlove: Looks like ruby / rails is used for emergency gas shutoff systems at Tokyo Gas: http://slidesha.re/hFsGY5

Przy okazji „rails routing quiz”:

    https://gist.github.com/871699

Prosty skrypt:

    ./check.sh tenderlove

Źródło:

    :::shell-unix-generic check.sh
    #!/bin/bash
    curl http://localhost:5984/nosql-slimmed/_design/test/_view/sun?startkey=\\[\"@$1\"\\]\&endkey=\\[\"@$1\",\\{\\}\\]\&reduce=false

Teraz, coś co było 110 razy retweeded:

    ./check.sh sstephenson
    RT @sstephenson: Rails 3.1 should ship with jQuery as its default JavaScript library
